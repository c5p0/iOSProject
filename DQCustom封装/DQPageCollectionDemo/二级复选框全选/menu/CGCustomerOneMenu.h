//
//  CGCustomerOneMenu.h
//  SecondMenuDemo
//
//  Created by duxiaoqiang on 2017/5/20.
//  Copyright © 2017年 professional. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGCustomerModelProtocol.h"
@class CGCustomerOneMenu;
@protocol CGCustomerOneMenuDataSource <NSObject>
@required
// 数量
- (NSInteger)menuView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
// 数据源
- (NSArray <id <CGCustomerModelProtocol>>*)menuChildModels:(CGCustomerOneMenu *)menuView section:(NSInteger )section;
@end

@protocol CGCustomerOneMenuDelegate <NSObject>
@optional
// 设置每个SectionHeader的高度,默认为60
- (CGFloat)menuView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
// 每个子item 点击事件
- (void)menuView:(UITableView *)tableView didSelectRow:(NSInteger )uiniqueId;

// 实时获取CheckBox选中的Item
- (void)menuViewOfSelectedData:(CGCustomerOneMenu *)menuView selectedData:(NSArray *)selectedItemArray;

@end

@interface CGCustomerOneMenu : UIView
@property (nonatomic,weak) id<CGCustomerOneMenuDataSource> dataSource;
@property (nonatomic,weak) id<CGCustomerOneMenuDelegate> delegate;

// 是否最后一个Cell 为圆角
@property (nonatomic,assign) BOOL isLastCellCorner ;
// 默认为70
@property (nonatomic,assign) CGFloat  rowHeight;

// 设置选中的Ids
@property (nonatomic,strong) NSMutableArray *selectedIds;
// 设置HeaderView
- (void)setTableHeaderView:(UIView *)headView;
- (void)reloadData;
@end
