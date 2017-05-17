//
//  CGCalendarView.h
//  SecondMenuDemo
//
//  Created by duxiaoqiang on 2017/5/16.
//  Copyright © 2017年 professional. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CGCalendarView : UIView
// 需要回显的日期 2017-07-16格式
@property (nonatomic,strong) NSString *backShowDate;
// 选中数据回传数据
@property (nonatomic,strong) void (^selectedItemClick)(NSString * selectedDate);
// 异常数据数组格式
@property (nonatomic,strong) NSMutableArray *exceptionDataArray;
// 显示View
- (void)showView;

@end
