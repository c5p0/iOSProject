//
//  DQPageTitleView.h
//  CGNewsDemo
//  咨询首页titleView
//  Created by duxiaoqiang on 17/3/22.
//  Copyright © 2017年 professional. All rights reserved.
//

#import <UIKit/UIKit.h>
#define RGB(r, g, b) [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:1.0f]
#define kScreenW  [UIScreen mainScreen].bounds.size.width
@class DQPageTitleView;
@class DQTitleStyle;
@protocol DQPageTitleViewDelegate<NSObject>
- (void)pageTitleView:(DQPageTitleView *)pageTitleView selectedIndex:(NSInteger )index;
@end
@interface DQPageTitleView : UIView
- (instancetype)initPageTitle:(NSArray *)titles withFrame:(CGRect )frame style:(DQTitleStyle *)style;
@property (nonatomic,weak) id<DQPageTitleViewDelegate> delegate;

/**
 设置标题滚动的位置

 @param progress 滚动进度
 @param sourceIndex 源角标
 @param targetIndex 目标角标
 */
- (void)setCurrentIndex:(CGFloat )progress sourceIndex:(NSInteger )sourceIndex targetIndex:(NSInteger )targetIndex;

- (void)setScrollViewOffSet;
@end
