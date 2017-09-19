//
//  CGCustomerSencodMenu.m
//  SecondMenuDemo
//
//  Created by duxiaoqiang on 2017/5/15.
//  Copyright © 2017年 professional. All rights reserved.
//

#import "CGCustomerSencodMenu.h"
#import "CGCustomerSencodMenuSectionView.h"
#import "CGCustomerSecondMenuCell.h"
static NSString * const defaultMenuCellID = @"defaultMenuCellID";
@interface CGCustomerSencodMenu()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
// 一级模型显示
@property (nonatomic,strong) NSArray<id <CGCustomerModelProtocol>> *parentModels;
// 记录右边箭头展开或者收起，用id唯一作为key,YES或No表示是否展开，默认收缩
@property (nonatomic,strong) NSMutableDictionary *recoderArrowStatusDict;
// 记录选中的父级数组
@property (nonatomic,strong) NSMutableArray *selectedParentArray;
// 记录选中的孩子数组
@property (nonatomic,strong) NSMutableArray *selectedChildArray;
// 记录当前一共有多少Section
@property (nonatomic,assign) NSInteger totalSection ;

@end
@implementation CGCustomerSencodMenu

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI:frame];
    }
    return self;
}



#pragma mark - UITableViewDataSource UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger sectionNum = 0;
    if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInMeunView:)]) {
        sectionNum = [self.dataSource numberOfSectionsInMeunView:tableView];
    }
    if (self.isShowAll) {
        sectionNum = sectionNum + 1;
    }
    self.totalSection = sectionNum;
    return sectionNum;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numOfSection = 0;
    
    if (self.isShowAll && section == 0) {
        numOfSection = 0;
    }else
    {
        section = self.isShowAll ? section - 1 : section;
        if ([self.dataSource respondsToSelector:@selector(menuView:numberOfRowsInSection:)]) {
            numOfSection = [self.dataSource menuView:tableView numberOfRowsInSection:section];
        }
      
        id<CGCustomerModelProtocol> model = self.parentModels[section];
        if ([[self.recoderArrowStatusDict objectForKey:@(model.uiniqueId)] integerValue] == 0) {
            numOfSection = 0;
        }

    }
    return numOfSection;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGCustomerSencodMenuSectionView * sectionView = [CGCustomerSencodMenuSectionView initHeaderView];
    sectionView.countLabel.hidden = YES;
    sectionView.isShowCheckBox = self.isShowCheckBox;
     __weak typeof(self) wakeSelf = self;
    if (self.isShowAll && section == 0) {
        BOOL isSelected = [self isSelectedAll];
        NSString * showText = isSelected ? @"取消全选" : @"全选";
        sectionView.gradeLable.text = showText;
        sectionView.checkBtn.selected = isSelected;
        sectionView.arrowIV.hidden = YES;
        sectionView.section = section;
    }else
    {
        
        section = self.isShowAll ? section - 1 : section;
        id<CGCustomerModelProtocol> model = self.parentModels[section];
        sectionView.model = model;
        // 旋转箭头
        if ([[self.recoderArrowStatusDict objectForKey:@(model.uiniqueId)] integerValue] == 1) {
            sectionView.arrowIV.transform = CGAffineTransformMakeRotation(M_PI/2);
        }else
        {
            sectionView.arrowIV.transform = CGAffineTransformIdentity;
        }
        sectionView.arrowIV.hidden = NO;
        sectionView.section = section;
        // 显示复选框状态
        if ([self.selectedParentArray containsObject:@(model.uiniqueId)]) {
            sectionView.checkBtn.selected = YES;
        }else
        {
            sectionView.checkBtn.selected = NO;
        }
        // 进入回显
        NSArray * childModels = [self.dataSource menuChildModels:self section:section];
        for (id<CGCustomerModelProtocol> model in childModels) {
            if ([self.selectedChildArray containsObject:@(model.uiniqueId)]) {
                // 处理上级以及全选复选框操作
                sectionView.checkBtn.selected = YES;
                break;
            }
        }
    }
    
    // 处理箭头点击
    sectionView.arrowBtnBlock = ^(NSInteger uiqueId) {
        if ([[wakeSelf.recoderArrowStatusDict objectForKey:@(uiqueId)] integerValue] == 0) {
             [wakeSelf.recoderArrowStatusDict setObject:@1 forKey:@(uiqueId)];
        }else{
            [wakeSelf.recoderArrowStatusDict setObject:@0 forKey:@(uiqueId)];
        }
        [wakeSelf.tableView reloadData];
    };
    
    // 处理复选框按钮点击事件
    sectionView.checkBoxBlock = ^(CGCustomerSencodMenuSectionView * sectionView,id<CGCustomerModelProtocol> model, BOOL isCheck) {
        if (isCheck) {
            // 全选处理
            if (model == nil) {
                sectionView.gradeLable.text = @"取消全选";
                [wakeSelf addALLParentAndChildToArray];
            }else{
                [wakeSelf.selectedParentArray addObject:@(model.uiniqueId)];
                [wakeSelf selectedAllChild:sectionView.section];
            }

        }else
        {
            if (model == nil) {
                sectionView.gradeLable.text = @"全选";
                [wakeSelf removeALLParentAndChildFromArray];
            }else{
                [wakeSelf.selectedParentArray removeObject:@(model.uiniqueId)];
                [wakeSelf removeAllChild:sectionView.section];
            }
        }
        [wakeSelf feachSelectedData];
        [wakeSelf.tableView reloadData];
    };
    return sectionView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGCustomerSecondMenuCell * cell = [tableView dequeueReusableCellWithIdentifier:defaultMenuCellID forIndexPath:indexPath];
    cell.isShowCheckBox = self.isShowCheckBox;
    NSInteger section = self.isShowAll ? indexPath.section -1 : indexPath.section;
    NSArray * childModels = [self.dataSource menuChildModels:self section:section];
    id<CGCustomerModelProtocol> model = childModels[indexPath.row];
    cell.model = model;
    __weak typeof(self) wakeSelf = self;
    // 处理cell上面的复选框选中未选中状态
    if ([self.selectedChildArray containsObject:@(model.uiniqueId)]) {
        cell.checkBtn.selected = YES;
    }else{
        cell.checkBtn.selected = NO;
    }
    // 隐藏最后一条数据滚动线
    cell.roundCornerType = KKRoundCornerCellTypeDefault;
    if (childModels.count == indexPath.row + 1) {
        cell.scrollLine.hidden = YES;
        if (self.isLastCellCorner) {
            cell.roundCornerType = KKRoundCornerCellTypeBottom;
        }

    }else{
        cell.scrollLine.hidden = NO;
        cell.roundCornerType = KKRoundCornerCellTypeDefault;
    }
    // 处理复选框点击事件
    cell.checkBoxBlock = ^(id<CGCustomerModelProtocol> model, BOOL isChecked) {
        if (isChecked) {
            [wakeSelf.selectedChildArray addObject:@(model.uiniqueId)];
           
        }else{
            [wakeSelf.selectedChildArray removeObject:@(model.uiniqueId)];
        }
        // 处理上级以及全选复选框操作
        [wakeSelf dealParentCheckBox:section];
    };
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat defaltSectionHeaderH = 70;
    if ([self.dataSource respondsToSelector:@selector(menuView:heightForHeaderInSection:)]) {
        defaltSectionHeaderH = [self.delegate menuView:tableView heightForHeaderInSection:section];
    }
    return defaltSectionHeaderH;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat defaltSectionFooterH = 2;
    if ([self.dataSource respondsToSelector:@selector(menuView:heightForFooterInSection:)]) {
        defaltSectionFooterH = [self.delegate menuView:tableView heightForFooterInSection:section];
    }
    return defaltSectionFooterH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSInteger section = self.isShowAll ? indexPath.section -1 : indexPath.section;
    NSArray * childModels = [self.dataSource menuChildModels:self section:section];
    id<CGCustomerModelProtocol> model = childModels[indexPath.row];
    if([self.delegate respondsToSelector:@selector(menuView:didSelectRow:)]){
        [self.delegate menuView:tableView didSelectRow:model.uiniqueId];
    }
}

#pragma mark - 私有方法
// 设置UI
- (void)setupUI:(CGRect) frame
{
    CGRect tableFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    self.tableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 70;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.isShowAll = YES; // 默认显示全选
    self.isShowCheckBox = YES;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CGCustomerSecondMenuCell class]) bundle:nil] forCellReuseIdentifier:defaultMenuCellID];
    [self addSubview:self.tableView];
}
// 设置行高
- (void)setRowHeight:(CGFloat)rowHeight
{
    _rowHeight = rowHeight;
    self.tableView.rowHeight = self.rowHeight > 0 ? self.rowHeight : 70;
}
// 刷新表格
- (void)reloadData
{
    if (self.tableView) {
        [self.tableView reloadData];
    }
}
// 全选某个父节点下面的子节点
- (void)selectedAllChild:(NSInteger )section
{
    NSArray * childModels = [self.dataSource menuChildModels:self section:section];
    for (id<CGCustomerModelProtocol>  model in childModels) {
        [self.selectedChildArray addObject:@(model.uiniqueId)];
    }
}
// 移除某个父节点下面的全部子节点
- (void)removeAllChild:(NSInteger )section
{
    NSArray * childModels = [self.dataSource menuChildModels:self section:section];
    for (id<CGCustomerModelProtocol>  model in childModels) {
        [self.selectedChildArray removeObject:@(model.uiniqueId)];
    }
}
// 处理父节点以及全选
- (void)dealParentCheckBox:(NSInteger)section
{
     id<CGCustomerModelProtocol> parentModel = self.parentModels[section];
     NSArray * childModels = [self.dataSource menuChildModels:self section:section];
     NSInteger *selectedCount = 0;
     for (id<CGCustomerModelProtocol>  model in childModels) {
         if ([self.selectedChildArray containsObject:@(model.uiniqueId)]) {
             selectedCount++;
             if (![self.selectedParentArray containsObject:@(parentModel.uiniqueId)]) {
                 [self.selectedParentArray addObject:@(parentModel.uiniqueId)];
             }
         }
     }
    if (selectedCount == 0) {
         [self.selectedParentArray removeObject:@(parentModel.uiniqueId)];
    }
    [self feachSelectedData];
    [self.tableView reloadData];
}

// 实时获取选中的数据
- (void)feachSelectedData
{
    if ([self.delegate respondsToSelector:@selector(menuViewOfSelectedData:selectedData:)]) {
        [self.delegate menuViewOfSelectedData:self selectedData:self.selectedChildArray];
    }
}
// 添加所有的父节点和子节点到对应的数组
- (void)addALLParentAndChildToArray
{
    // 先移除所有的
    [self.selectedParentArray removeAllObjects];
    [self.selectedChildArray removeAllObjects];
    for (id<CGCustomerModelProtocol>  parentModel in self.parentModels) {
        [self.selectedParentArray addObject:@(parentModel.uiniqueId)];
    }
    NSInteger section = self.isShowAll ? self.totalSection - 1 : self.totalSection;
    for (int i = 0; i< section; i++) {
         NSArray * childModels = [self.dataSource menuChildModels:self section:i];
         for (id<CGCustomerModelProtocol>  childModel in childModels) {
            [self.selectedChildArray addObject:@(childModel.uiniqueId)];
         }
    }
}
// 移除所有的父节点和子节点到对应的数组
- (void)removeALLParentAndChildFromArray
{
    [self.selectedParentArray removeAllObjects];
    [self.selectedChildArray removeAllObjects];
}
// 计算一共有多少行
- (NSInteger)totalRows
{
    NSInteger totalCount = 0;
    NSInteger section = self.isShowAll ? self.totalSection - 1 : self.totalSection;
    for (int i = 0; i< section; i++) {
        NSArray * childModels = [self.dataSource menuChildModels:self section:i];
        totalCount += childModels.count;
    }
    return totalCount;
}
// 返回判断是否选中全选
- (BOOL)isSelectedAll
{
    // 总孩子数
    NSInteger totalChildCount = [self totalRows];
    // 总父级数
    NSInteger totalParentCount = self.parentModels.count;
    
    BOOL isSelected = NO;
    if (totalChildCount == 0) {
        if (totalParentCount > 0 && self.selectedParentArray.count == totalParentCount) {
            isSelected = YES;
        }else{
            isSelected = NO;
        }
    }else if(totalChildCount > 0 && self.selectedChildArray.count == totalChildCount)
    {
        isSelected = YES;
    }
    return isSelected;
}

- (void)setTableHeaderView:(UIView *)headView
{
    self.tableView.tableHeaderView = headView;
}

- (void)setSelectedIds:(NSMutableArray *)selectedIds
{
    _selectedIds = selectedIds;
    for (NSNumber * uniqueId in selectedIds) {
        if (![self.selectedChildArray containsObject:uniqueId]) {
            [self.selectedChildArray addObject:uniqueId];
        }
    }
    
}

#pragma mark - 懒加载
-(NSArray* )parentModels
{
    if(!_parentModels)
    {
        _parentModels = [NSArray array];
        
    }
    if ([_dataSource respondsToSelector:@selector(menuOfParentModels:)]) {
        _parentModels = [_dataSource menuOfParentModels:self];
        if (self.recoderArrowStatusDict.count == 0) {
            for (id<CGCustomerModelProtocol> model in  _parentModels) {
                [self.recoderArrowStatusDict setObject:@0 forKey:@(model.uiniqueId)];
            }
            
        }
    }
    return _parentModels;
}


-(NSMutableDictionary* )recoderArrowStatusDict
{
    if(!_recoderArrowStatusDict)
    {
        _recoderArrowStatusDict = [NSMutableDictionary dictionary];
    }
    return _recoderArrowStatusDict;
}
-(NSMutableArray* )selectedParentArray
{
    if(!_selectedParentArray)
    {
        _selectedParentArray = [NSMutableArray array];
    }
    return _selectedParentArray;
}

-(NSMutableArray* )selectedChildArray
{
    if(!_selectedChildArray)
    {
        _selectedChildArray = [NSMutableArray array];
    }
    return _selectedChildArray;
}
@end
