//
//  UIView+BlankPage.h
//  MyTraning
//
//  Created by duxiaoqiang on 2017/7/27.
//  Copyright © 2017年 professional. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (BlankPage)

#pragma mark ------------  自定义参数  -------------

/**
 空白页背景色
 默认灰色
 */
@property (nonatomic, strong) UIColor *blankPageBackColor;

/**
 空白页整个页面顶部偏移量
 默认是0，
 大于0为向下偏移
 小于0为向上偏移
 */
@property (nonatomic, assign) CGFloat blankPageTop;

/**
 空白图片顶部偏移量
 默认为0，
 大于0为向下偏移
 小于0为向上偏移
 */
@property (nonatomic, assign) CGFloat blankImageTop;

/**
 图片及按钮宽度，相对于背景底视图的比例
 默认0.6
 越大，图片等显示得越宽
 */
@property (nonatomic, assign) CGFloat blankPageWidthScale;

/**
 图片与文本，文本与按钮 之间的间距
 默认20.f
 */
@property (nonatomic, assign) CGFloat blankPageDistanceBetweenPicturesAndText;

/**
 按钮与底部提示信息的间距
 默认20.f
 */
@property (nonatomic, assign) CGFloat blankPageDistanceBetweenBtnAndBottomTip;

/**
 底部提示信息的居中方式
 默认居中
 */
@property (nonatomic, assign) NSTextAlignment blankPageBottomTipTextAlignment;

/**
 按钮样式
 0 为黄底白字 (默认)
 1 为白底黄字
 */
@property (nonatomic, assign) NSInteger blankPageBtnType;

#pragma mark ------------  展示方法  -------------  先配置自定义参数，后调用展示方法  -----------

/**
 展示空白界面
 
 @param imageName 图片名称
 @param title 提示信息
 @param btnTitles 按钮显示的标题，数组数量决定显示的个数
 @param bottomTipText 底部提示信息
 @param actionBlock 点击按钮回调
 
 |
 |
 |
 V
 底部有参考
 
 */
- (void)showBlankPageWithImageName:(NSString *)imageName
                             title:(NSString *)title
                         btnTitles:(NSArray <NSString *> *)btnTitles
                     bottomTipText:(NSString *)bottomTipText
                       actionBlock:(void (^)(NSInteger btnIndex))actionBlock;

/**
 隐藏空白视图
 */
- (void)hideBlankPage;

@end
