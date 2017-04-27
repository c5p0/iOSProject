//
//  CustomPlaceholderTextView.h
//  newDemo
//
//  Created by duxiaoqiang on 16/5/20.
//  Copyright © 2016年 炫嘉科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomPlaceholderTextView : UITextView
/** 占位文字 */
@property (nonatomic, copy) NSString *placeholder;
/** 占位文字的颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;
@end
