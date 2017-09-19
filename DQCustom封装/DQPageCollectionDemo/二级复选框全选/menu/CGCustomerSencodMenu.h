//
//  CGCustomerSencodMenu.h
//  SecondMenuDemo
//
//  Created by duxiaoqiang on 2017/5/15.
//  Copyright © 2017年 professional. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGCustomerModelProtocol.h"
@class CGCustomerSencodMenu;
@protocol CGCustomerSencodMenuDataSource <NSObject>
@required
// 一级菜单数量 isShowAll 是否显示全选按钮
- (NSInteger)numberOfSectionsInMeunView:(UITableView *)tableView;
// 每个section里面的二级菜单的数量
- (NSInteger)menuView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
// 一级菜单数据源来源
- (NSArray <id <CGCustomerModelProtocol>>*)menuOfParentModels:(CGCustomerSencodMenu *)menuView;
// 子菜单数据源
- (NSArray <id <CGCustomerModelProtocol>>*)menuChildModels:(CGCustomerSencodMenu *)menuView section:(NSInteger )section;
@end

@protocol CGCustomerSencodMenuDelegate <NSObject>
@optional
// 设置每个SectionHeader的高度,默认为70
- (CGFloat)menuView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
// 设置每个SectionFooter的高度,默认为2
- (CGFloat)menuView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
// 每个子item 点击事件
- (void)menuView:(UITableView *)tableView didSelectRow:(NSInteger )uiniqueId;

// 实时获取CheckBox选中的Item
- (void)menuViewOfSelectedData:(CGCustomerSencodMenu *)menuView selectedData:(NSArray *)selectedItemArray;


@end

@interface CGCustomerSencodMenu : UIView

@property (nonatomic,weak) id<CGCustomerSencodMenuDataSource> dataSource;
@property (nonatomic,weak) id<CGCustomerSencodMenuDelegate> delegate;
// 是否最后一个Cell 为圆角
@property (nonatomic,assign) BOOL isLastCellCorner ;
// 默认为70
@property (nonatomic,assign) CGFloat  rowHeight;
// 是否显示全选按钮
@property (nonatomic,assign) BOOL isShowAll;
// 是否显示复选框
@property (nonatomic,assign) BOOL isShowCheckBox ;
// 设置选中的Ids
@property (nonatomic,strong) NSMutableArray *selectedIds;
// 设置HeaderView
- (void)setTableHeaderView:(UIView *)headView;
// 刷新TabelView
- (void)reloadData;

@end
