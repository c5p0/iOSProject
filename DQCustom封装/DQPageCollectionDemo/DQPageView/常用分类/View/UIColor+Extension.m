//
//  UIColor+Extension.m
//  DQPageCollectionDemo
//
//  Created by duxiaoqiang on 2017/4/26.
//  Copyright © 2017年 professional. All rights reserved.
//

#import "UIColor+Extension.h"

@implementation UIColor (Extension)
+ (UIColor *)randomColor
{
    return [UIColor colorWithRed:arc4random_uniform(256)/255.0f green:arc4random_uniform(256)/255.0f blue:arc4random_uniform(256)/255.0f alpha:1.0];
}

+ (UIColor *)colorWithRGB:(CGFloat )red green:(CGFloat)green blue:(CGFloat )blue
{
    return [UIColor colorWithRed: red/255.0f green: green/255.0f blue: blue/255.0f alpha:1.0];
}

@end
