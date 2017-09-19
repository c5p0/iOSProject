//
//  CGCustomerOneMenu.m
//  SecondMenuDemo
//
//  Created by duxiaoqiang on 2017/5/20.
//  Copyright © 2017年 professional. All rights reserved.
//

#import "CGCustomerOneMenu.h"
#import "CGCustomerSencodMenuSectionView.h"
#import "CGCustomerSecondMenuCell.h"
static NSString * const defaultMenuCellID = @"defaultMenuCellID";
@interface CGCustomerOneMenu()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *selectedChildArray;
@end
@implementation CGCustomerOneMenu

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI:frame];
    }
    return self;
}



#pragma mark - UITableViewDataSource UITableViewDelegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numOfSection = 0;
    if ([self.dataSource respondsToSelector:@selector(menuView:numberOfRowsInSection:)]) {
        numOfSection = [self.dataSource menuView:tableView numberOfRowsInSection:section];
    }
    return numOfSection;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGCustomerSencodMenuSectionView * sectionView = [CGCustomerSencodMenuSectionView initHeaderView];
    sectionView.countLabel.hidden = YES;
    __weak typeof(self) wakeSelf = self;
    BOOL isSelected = [self isSelectedAll];
    NSString * showText = isSelected ? @"取消全选" : @"全选";
    sectionView.gradeLable.text = showText;
    sectionView.checkBtn.selected = isSelected;
    sectionView.arrowIV.hidden = YES;
    // 处理复选框按钮点击事件
    sectionView.checkBoxBlock = ^(CGCustomerSencodMenuSectionView * sectionView,id<CGCustomerModelProtocol> model, BOOL isCheck) {
         [wakeSelf.selectedChildArray removeAllObjects];
        if (isCheck) {
           
            // 全选处理
            if (model == nil) {
                sectionView.gradeLable.text = @"取消全选";
                NSArray * childModels = [self.dataSource menuChildModels:self section:0];
                for (id<CGCustomerModelProtocol>  model in childModels) {
                    [wakeSelf.selectedChildArray addObject:@(model.uiniqueId)];
                }
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
    NSArray * childModels = [self.dataSource menuChildModels:self section:indexPath.section];
    id<CGCustomerModelProtocol> model = childModels[indexPath.row];
    cell.isShowOneMenu = YES;
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
        [wakeSelf.tableView reloadData];
        [wakeSelf feachSelectedData];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat defaltSectionHeaderH = 60;
    if ([self.dataSource respondsToSelector:@selector(menuView:heightForHeaderInSection:)]) {
        defaltSectionHeaderH = [self.delegate menuView:tableView heightForHeaderInSection:section];
    }
    return defaltSectionHeaderH;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSArray * childModels = [self.dataSource menuChildModels:self section:0];
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
// 实时获取选中的数据
- (void)feachSelectedData
{
    if ([self.delegate respondsToSelector:@selector(menuViewOfSelectedData:selectedData:)]) {
        [self.delegate menuViewOfSelectedData:self selectedData:self.selectedChildArray];
    }
}


// 返回判断是否选中全选
- (BOOL)isSelectedAll
{
    NSInteger totalCount = 0;
    if ([self.dataSource respondsToSelector:@selector(menuView:numberOfRowsInSection:)]) {
        totalCount = [self.dataSource menuView:self.tableView numberOfRowsInSection:0];
    }
    if (self.selectedChildArray.count == totalCount) {
        return YES;
    }
    return NO;
}

- (void)setTableHeaderView:(UIView *)headView
{
    self.tableView.tableHeaderView = headView;
}

- (void)setSelectedIds:(NSMutableArray *)selectedIds
{
    _selectedIds = selectedIds;
    for (NSNumber * uniqueId in selectedIds) {
        if (![_selectedChildArray containsObject:uniqueId]) {
            [_selectedChildArray addObject:uniqueId];
        }
    }

}
#pragma mark - 懒加载
-(NSMutableArray* )selectedChildArray
{
    if(!_selectedChildArray)
    {
        _selectedChildArray = [NSMutableArray array];
        
    }
    return _selectedChildArray;
}


@end
