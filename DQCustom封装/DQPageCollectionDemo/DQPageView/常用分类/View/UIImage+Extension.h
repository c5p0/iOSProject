//
//  UIImage+Extension.h
//  newDemo
//
//  Created by duxiaoqiang on 16/5/20.
//  Copyright © 2016年 炫嘉科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreImage/CoreImage.h>

@interface UIImage (Extension)
/**
 *  图片裁剪成圆形图片
 *
 *  @return 裁剪后的图片
 */
- (UIImage *)circleImage;
/**
 *  根据颜色和尺寸来绘制图片
 *
 *  @param color 图片的颜色
 *  @param size  图片的尺寸
 *  @return 绘制后的图片
 */
-  (UIImage *)imageWithColor:(UIColor *)color withImageSize:(CGSize )size;
/**
 *  生成二维码
 */
+ (UIImage *)QRCodeForString:(NSString *)qrString size:(CGFloat)size;
+ (UIImage *)QRCodeForString:(NSString *)qrString size:(CGFloat)size fillColor:(UIColor *)fillColor;

/**
 上传图片太大，压缩图片

 @param image 原始图片
 @return 压缩后的图片
 */
-(UIImage *)resizeImage:(UIImage *)image;

@end
