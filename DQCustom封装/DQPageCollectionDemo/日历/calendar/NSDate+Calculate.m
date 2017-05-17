//
//  NSDate+Calculate.m
//  SecondMenuDemo
//
//  Created by duxiaoqiang on 2017/5/16.
//  Copyright © 2017年 professional. All rights reserved.
//

#import "NSDate+Calculate.h"

@implementation NSDate (Calculate)
+ (NSInteger)totaldaysInMonth:(NSDate *)date{
    NSRange daysInLastMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInLastMonth.length;
}


+ (NSInteger)month:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return components.month;
}
+ (NSInteger)day:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return components.day;
}
+ (NSInteger)year:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return components.year;
}

+ (NSInteger)firstWeekdayInThisMonth:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //设置每周的第一天从周几开始,默认为1,从周日开始
    [calendar setFirstWeekday:2];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    //若设置从周日开始算起则需要减一,若从周一开始算起则不需要减
    return firstWeekday;
}


+ (NSDate *)converFromStringToDate:(NSString *)dateString
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSDate *newdate = [formatter dateFromString:dateString];
    return newdate;
}
+ (NSArray *)feachOfMonthArray:(NSDate *)date
{
    //获取月份
    NSDate * currentDate = date;
    NSMutableArray * dayArray = [NSMutableArray array];
    //获取该月第一天星期几
    NSInteger firstDayInThisMounth = [NSDate firstWeekdayInThisMonth:currentDate];
    //该月的有多少天daysInThisMounth
    NSInteger daysInThisMounth = [NSDate totaldaysInMonth:currentDate];
    NSString *string = @"";
    for (int j = 1; j <= (daysInThisMounth > 29 && (firstDayInThisMounth == 6 || firstDayInThisMounth ==7) ? 42 : 35) ; j++) {
        if (j < firstDayInThisMounth || j > daysInThisMounth + firstDayInThisMounth - 1) {
            string = @"";
            [dayArray addObject:string];
        }else{
            string = [NSString stringWithFormat:@"%ld",j - firstDayInThisMounth + 1];
            [dayArray addObject:string];
        }
    }
    return dayArray;
}
+ (NSString *)feachByDate:(NSDate *)date
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    // 获取年
    NSInteger year = components.year;
    // 获取月
    NSInteger month = components.month;
    NSString * showYearAndMonth = [NSString stringWithFormat:@"%zd-%02zd",year,month];
    return showYearAndMonth;
}

+ (NSDate *)feachPreDate:(NSDate *)currentDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:currentDate];
    // 获取年
    NSInteger year = components.year;
    // 获取月
    NSInteger month = components.month;
    if (month == 1) {
        year = year - 1;
        month = 12;
    }else{
        month = month - 1;
    }
    components.year = year;
    components.month = month;
    components.day = 1;
    NSDate *preNSDate = [calendar dateFromComponents:components];
    return preNSDate;
}

+ (NSDate *)feachNextDate:(NSDate *)currentDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:currentDate];
    // 获取年
    NSInteger year = components.year;
    // 获取月
    NSInteger month = components.month;
    if (month == 12) {
        year = year + 1;
        month = 1;
    }else
    {
        month = month +1;
    }
    components.year = year;
    components.month = month;
    components.day = 1;
    NSDate *nextNSDate = [calendar dateFromComponents:components];
    return nextNSDate;
}

+ (BOOL)compareDate:(NSDate *)currentDate target:(NSDate *)targetDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *currentComps = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:currentDate];
    
    NSDateComponents *targetComps = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:targetDate];
    if (currentComps.year == targetComps.year && currentComps.month == targetComps.month) {
        return YES;
    }
    return NO;
}
+ (NSString *)convertByDate:(NSDate *)date
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    // 获取年
    NSInteger year = components.year;
    // 获取月
    NSInteger month = components.month;
    NSString * showYearAndMonth = [NSString stringWithFormat:@"%zd-%02zd-%02zd",year,month,components.day];
    return showYearAndMonth;

}
@end
