//
//  DQPageContentView.h
//  CGNewsDemo
//  资讯内容
//  Created by duxiaoqiang on 17/3/22.
//  Copyright © 2017年 professional. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DQPageContentView;
@protocol DQPageContentViewDelegate<NSObject>
@required
- (void)pageContentView:(DQPageContentView *)pageContentView progress:(CGFloat )progress sourceIndex:(NSInteger )sourceIndex targetIndex:(NSInteger)targetIndex;
@optional
- (void)contentViewEndScroll:(DQPageContentView *)pageContentView;
@end
@interface DQPageContentView : UIView
- (instancetype)initPageContent:(NSArray *)childVcs withFrame:(CGRect )frame;
@property (nonatomic,weak) id<DQPageContentViewDelegate> delegate;
/**
 切换视图

 @param index 当前点击的角标
 */
- (void)setPageContentOffSet:(NSInteger )index;
@end
