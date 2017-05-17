//
//  CalendarButton.m
//  SecondMenuDemo
//
//  Created by duxiaoqiang on 2017/5/17.
//  Copyright © 2017年 professional. All rights reserved.
//

#import "CalendarButton.h"

@implementation CalendarButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(20, 5, 25, 25);
}
- (void)setHighlighted:(BOOL)highlighted
{
}

@end
