//
//  DQPageView.m
//  DQCustom封装
//
//  Created by duxiaoqiang on 2017/4/26.
//  Copyright © 2017年 professional. All rights reserved.
//

#import "DQPageView.h"
#import "DQPageTitleView.h"
#import "DQPageContentView.h"
#import "DQTitleStyle.h"

@interface DQPageView()<DQPageTitleViewDelegate,DQPageContentViewDelegate>
@property (nonatomic,strong) DQPageTitleView *titleView;
@property (nonatomic,strong) DQPageContentView *contentView;
@property (nonatomic,strong) NSArray<NSString *> *titles;
@property (nonatomic,strong) NSArray<UIViewController *> *childVcs;
@property (nonatomic,weak) UIViewController *parentVc; // 不能对父控制器强引用，会造成循环引用
@property (nonatomic,strong) DQTitleStyle *style;
@end
@implementation DQPageView


-(instancetype)initPageView:(CGRect)frame titles:(NSArray<NSString *> *)titles childVcs:(NSArray<UIViewController *> *)childVcs parentVc:(UIViewController *)parentVc style:(DQTitleStyle *)style
{
    if (self = [super init])
    {
        self.frame = frame;
        self.titles = titles;
        self.childVcs = childVcs;
        self.parentVc = parentVc;
        self.style = style;
        [self setupUI];
        parentVc.automaticallyAdjustsScrollViewInsets = false;
    }
    return self;
}

- (void)setupUI
{
    CGFloat titleH = self.style.titleHeight;
    CGRect titleFrame = CGRectMake(0, 0, self.frame.size.width, titleH);
    self.titleView = [[DQPageTitleView alloc] initPageTitle:self.titles withFrame:titleFrame style:self.style];
    self.titleView.delegate = self;
    [self addSubview:self.titleView];
    
    for (UIViewController * vc  in  self.childVcs) {
        vc.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256)/255.0f green:arc4random_uniform(256)/255.0f blue:arc4random_uniform(256)/255.0f alpha:1.0];
        [self.parentVc addChildViewController:vc];
    }
    // 创建内容
    CGRect contentFrame = CGRectMake(0, titleH, self.frame.size.width, self.frame.size.height - titleH);
    self.contentView = [[DQPageContentView alloc] initPageContent:self.childVcs withFrame:contentFrame];
    self.contentView.delegate = self;
    [self addSubview:self.contentView];
    
}

#pragma mark - 设置Title 和 Conetent代理

- (void)pageTitleView:(DQPageTitleView *)pageTitleView selectedIndex:(NSInteger)index
{
    [self.contentView setPageContentOffSet:index];
}
- (void)pageContentView:(DQPageContentView *)pageContentView progress:(CGFloat)progress sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex
{
    [self.titleView setCurrentIndex:progress sourceIndex:sourceIndex targetIndex:targetIndex];
}
- (void)contentViewEndScroll:(DQPageContentView *)pageContentView
{
    [self.titleView setScrollViewOffSet];
}

@end
