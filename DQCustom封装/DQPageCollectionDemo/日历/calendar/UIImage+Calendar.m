//
//  UIImage+Extension.m
//  SecondMenuDemo
//
//  Created by duxiaoqiang on 2017/5/16.
//  Copyright © 2017年 professional. All rights reserved.
//

#import "UIImage+Calendar.h"

@implementation UIImage (Calendar)
+ (UIImage *)imageWithRectColor:(UIColor *)color withFrameSize:(CGSize) size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextStrokeRect(context,  rect);
    CGContextSetLineWidth(context, 2);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)drawTriangle:(UIColor *)color withFrameSize:(CGSize ) size withRectSize:(CGSize )rectSize isShowBorderColor:(BOOL) showBorderColor
{
    UIGraphicsBeginImageContext(rectSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 画带边框的矩形
    if (showBorderColor) {
        CGContextSetStrokeColorWithColor(context, color.CGColor);
        CGContextStrokeRect(context,  CGRectMake(0, 0, rectSize.width, rectSize.height));
        CGContextSetLineWidth(context, 2);

    }else
    {
        // 画不带边框的矩形
        CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
        CGContextFillRect(context, CGRectMake(0, 0, rectSize.width, rectSize.height));

    }
    
    // 2.拼接路径
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGPoint startP = CGPointMake(rectSize.width - size.width, 0);
    
    [path moveToPoint:startP];
    
    [path addLineToPoint:CGPointMake(rectSize.width, 0)];
    
    [path addLineToPoint:CGPointMake(rectSize.width, size.height)];
    // 从路径的终点连接到起点
    [path closePath];
    [color setFill];
    [color setStroke];
    // 3.把路径添加到上下文
    CGContextAddPath(context, path.CGPath);
    
    CGContextDrawPath(context, kCGPathFillStroke);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
