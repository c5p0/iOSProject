//
//  UIImage+Extension.h
//  SecondMenuDemo
//
//  Created by duxiaoqiang on 2017/5/16.
//  Copyright © 2017年 professional. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Calendar)
+ (UIImage *)imageWithRectColor:(UIColor *)color  withFrameSize:(CGSize) size;


+ (UIImage *)drawTriangle:(UIColor *)color withFrameSize:(CGSize ) size withRectSize:(CGSize )rectSize isShowBorderColor:(BOOL) showBorderColor;
@end
