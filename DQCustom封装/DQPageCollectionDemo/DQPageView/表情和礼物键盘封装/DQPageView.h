//
//  DQPageView.h
//  DQCustom封装
//  对头部和内容进行封装暴露给外界使用
//  Created by duxiaoqiang on 2017/4/26.
//  Copyright © 2017年 professional. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DQTitleStyle;
@interface DQPageView : UIView
- (instancetype)initPageView:(CGRect )frame titles:(NSArray<NSString *> *)titles childVcs:(NSArray<UIViewController *> *)childVcs parentVc:(UIViewController *) parentVc style:(DQTitleStyle *)style;
@end
