//
//  XQBaseViewController.h
//  MyTraning
//
//  Created by duxiaoqiang on 2017/7/27.
//  Copyright © 2017年 professional. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XQBaseViewController : UIViewController
/**
 *  导航栏左侧按钮
 */
@property (nonatomic, strong) UIButton *backBtnItem;

/**
 *  导航栏右侧按钮
 */
@property (nonatomic, strong) UIButton *rightBtnItem;

/**
 *  导航栏右侧按钮是否为灰度,不可点击
 */
@property (nonatomic,assign) BOOL useGrayItem;

/**
 *  是否显示返回按钮
 */
@property (nonatomic, assign) BOOL useBackItem;

/**
 *  导航栏右按钮标题
 */
@property (nonatomic, copy) NSString *rightItemTitle;
@property (nonatomic, copy) NSAttributedString *rightItemAttributedTitle;
/**
 *  是否使用导航栏右按钮
 */
@property (nonatomic, getter=isUseRightItem) BOOL useRightItem;
/**
 *  导航栏返回按钮图片
 */
@property (nonatomic, strong) UIImage *backItemImage;

/**
 *  导航栏按钮响应 --- 返回事件：[super navBarButtonItemAction:sender]即可;
 *
 *  @param sender 参数
 */
- (void)navBarButtonItemAction:(id)sender;

/**
 进去该控制器判断是否需要检查登录操作，默认不需要检查登录
 */
@property (nonatomic,assign) BOOL isCheckLogin;

@end
