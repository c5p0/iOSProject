//
//  NSDate+Calculate.h
//  SecondMenuDemo
//
//  Created by duxiaoqiang on 2017/5/16.
//  Copyright © 2017年 professional. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Calculate)
// 获取当月共有多少天
+ (NSInteger)totaldaysInMonth:(NSDate *)date;
// 获取月
+ (NSInteger)month:(NSDate *)date;
// 获取日
+ (NSInteger)day:(NSDate *)date;
// 获取年
+ (NSInteger)year:(NSDate *)date;
// 获得当前月份第一天星期几
+ (NSInteger)firstWeekdayInThisMonth:(NSDate *)date;
// 获取每月里面的数组集合
+ (NSArray *)feachOfMonthArray:(NSDate *)date;
// 获取日期的年月组成字符串
+ (NSString *)feachByDate:(NSDate *)date;
// 从NString转换成NSDate
+ (NSDate *)converFromStringToDate:(NSString *)dateString;
// 获取上一个月的日期
+ (NSDate *)feachPreDate:(NSDate *)currentDate;
// 获取下一个月的日期
+ (NSDate *)feachNextDate:(NSDate *)currentDate;
// 比较两个日期是否是当月
+ (BOOL)compareDate:(NSDate *)currentDate target:(NSDate *)targetDate;
// 转换成2017-09-11这种格式
+ (NSString *)convertByDate:(NSDate *)date;
@end
