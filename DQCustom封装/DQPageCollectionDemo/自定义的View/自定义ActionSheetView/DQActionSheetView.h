//
//  DQActionView.h
//  DQCustom封装
//  自定义UIActionSheetView
//  Created by duxiaoqiang on 2017/7/15.
//  Copyright © 2017年 professional. All rights reserved.
//

#import <UIKit/UIKit.h>

#define Screen_Width [UIScreen mainScreen].bounds.size.width
#define Screen_Height [UIScreen mainScreen].bounds.size.height
#define Space_Line 10
@interface DQActionSheetView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIView *maskView;//背景
@property (nonatomic, strong) UITableView *tableView;//展示表格
@property (nonatomic, strong) NSArray *cellArray;//表格数组
@property (nonatomic,   copy) NSString *cancelTitle;//取消的标题设置
@property (nonatomic, strong) UIView *headView;//标题头视图
@property (nonatomic,   copy) void(^selectedBlock)(NSInteger);//选择单元格block
@property (nonatomic,   copy) void(^cancelBlock)();//取消单元格block


//初始化方法:参数一：标题，参数二：表格数组，参数三：取消的标题设置，参数四：选择单元格block，参数五：取消block
-(instancetype)initWithTitle:(NSString *)title cellArray:(NSArray *)cellArray cancelTitle:(NSString *)cancelTitle selectedBlock:(void(^)(NSInteger))selectedBlock cancelBlock:(void(^)())cancelBlock;

// 设置title的文本颜色
@property (nonatomic,strong) UIColor *titleColor;
// 设置cell上面的文本颜色
@property (nonatomic,strong) UIColor *contentColor;
@end
