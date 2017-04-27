//
//  UIImageView+Extension.h
//  newDemo
//
//  Created by duxiaoqiang on 16/5/20.
//  Copyright © 2016年 炫嘉科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Extension)
/**
 *  组合多张图，类似于微信图片组合
 *
 *  @param imageUrlArr 服务器返回的图片数组
 */
- (void)setImageWithImageUrlArray:(NSArray *)imageUrlArr;
@end
