//
//  DQPageTitleView.m
//  CGNewsDemo
//  显示的滚动的TitleView
//  Created by duxiaoqiang on 17/3/22.
//  Copyright © 2017年 professional. All rights reserved.
//

#import "DQPageTitleView.h"
#import "DQTitleStyle.h"
#import "DQTitleStyle.h"
static const CGFloat scrollLineHeight  = 1; // 滚动线的高度
@interface DQPageTitleView()
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) NSMutableArray *titleLables;
@property (nonatomic,strong) UILabel *scrollLineLabel; // 滚动线
@property (nonatomic,assign) NSInteger currentIndex;   // 当前滚动位置
@property (nonatomic,assign) NSInteger oldIndex ;
@property (nonatomic,strong) NSArray *kNormalColor;
@property (nonatomic,strong) NSArray *kSelectColor;
@property (nonatomic,strong) DQTitleStyle *style;
/** title数组*/
@property (nonatomic,strong) NSArray *titles;
@end
@implementation DQPageTitleView

- (instancetype)initPageTitle:(NSArray *)titles withFrame:(CGRect)frame style:(DQTitleStyle *)style
{
    self.titles = titles;
    self.style = style;
    return [self initWithFrame:frame];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}
- (void)setupUI
{
    self.backgroundColor = self.style.titleBgColor;
    self.kSelectColor = [self getRGBWithColor:self.style.selectedColor];
    self.kNormalColor = [self getRGBWithColor:self.style.normalColor];
    self.scrollView = [[UIScrollView alloc] init];
   [self addSubview:self.scrollView];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.frame = self.bounds;
    self.scrollView.scrollEnabled = self.style.isScrollEnable;
    CGFloat titleShowWidth = [UIScreen mainScreen].bounds.size.width / self.style.defaultCols;
    CGFloat scrollViewContentSizeW  = titleShowWidth * self.titles.count;
    self.scrollView.contentSize = CGSizeMake(scrollViewContentSizeW, 0);

    //添加UiLabel
    [self setupTitleLabel];
    // 是否显示滚动线条
    if (self.style.isShowLine) {
        // 添加黄色滚动线条
        [self setupScrollLine];
    }
}

- (NSArray *)getRGBWithColor:(UIColor *)color
{
    const CGFloat * components = CGColorGetComponents(color.CGColor);
    return @[@(components[0] *255),@(components[1]*255),@(components[2]*255)];
}
- (void)setupTitleLabel
{
    self.titleLables = [[NSMutableArray alloc] init];
    CGFloat titleW = [UIScreen mainScreen].bounds.size.width / self.style.defaultCols;
    CGFloat titleH = self.bounds.size.height - scrollLineHeight;
    CGFloat titleY = 0;
    for (NSInteger i = 0; i < self.titles.count; i++) {
        CGFloat titleX = i * titleW;
        UILabel * lable = [[UILabel alloc] init];
        lable.frame = CGRectMake(titleX, titleY, titleW, titleH);
        lable.tag = i;
        lable.text = self.titles[i];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.font = self.style.titleFontSize;
        lable.textColor = self.style.normalColor;
        lable.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLabelClick:)];
        [lable addGestureRecognizer:tap];
        [self.scrollView addSubview:lable];
        [self.titleLables addObject:lable];
        // 默认第一个颜色
        if (i == 0) {
            lable.textColor = self.style.selectedColor;
            lable.font = self.style.titleFontSize;
        }
    }
}

- (void)setupScrollLine
{
    UILabel *firstLabel = [self.titleLables firstObject];
    self.scrollLineLabel = [[UILabel alloc] init];
    self.scrollLineLabel.backgroundColor = RGB(255, 153, 0);
    self.scrollLineLabel.frame = CGRectMake(0, self.bounds.size.height - scrollLineHeight, firstLabel.bounds.size.width, scrollLineHeight);
    [self.scrollView addSubview:self.scrollLineLabel];
}

/**
 UILabel点击事件
 */
- (void)tapLabelClick:(UITapGestureRecognizer *)tapGes
{
    if ([tapGes.view isKindOfClass:[UILabel class]]) {

        UILabel * currentLabel = (UILabel *)tapGes.view;
        // 获取旧的Label
        UILabel * oldLabel = self.titleLables[self.currentIndex];
        if (currentLabel.tag == oldLabel.tag)return;
        // 设置label颜色
        currentLabel.textColor = self.style.selectedColor;
        oldLabel.textColor = self.style.normalColor;
        // 设置字体
        currentLabel.font = self.style.titleFontSize;
        oldLabel.font = self.style.titleFontSize;
        self.currentIndex = currentLabel.tag;
        // 设置滚动线的位置
        CGFloat scrollLineX =  currentLabel.tag * oldLabel.bounds.size.width;
        [UIView animateWithDuration:0.25 animations:^{
            CGRect frame  = self.scrollLineLabel.frame;
            frame.origin.x = scrollLineX;
            self.scrollLineLabel.frame = frame;
        }];
        
        if ([self.delegate respondsToSelector:@selector(pageTitleView:selectedIndex:)]) {
            [self.delegate pageTitleView:self selectedIndex:self.currentIndex];
        }
       // [self setScrollViewOffSet:currentLabel.center.x];
        [self setScrollViewOffSet];
    }
    
}

- (void)setCurrentIndex:(CGFloat)progress sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex
{
    // 移动黄色角标
    UILabel * sourceLabel = self.titleLables[sourceIndex];
    UILabel * targetLabel = self.titleLables[targetIndex];
    CGFloat marginW = targetLabel.frame.origin.x - sourceLabel.frame.origin.x;
    CGFloat moveX = marginW * progress;
    CGRect frame  = self.scrollLineLabel.frame;
    frame.origin.x = sourceLabel.frame.origin.x  + moveX;
    self.scrollLineLabel.frame = frame;
    CGFloat redDelta = [self.kSelectColor[0] floatValue] - [self.kNormalColor[0] floatValue];
    CGFloat greenDelta = [self.kSelectColor[1] floatValue] - [self.kNormalColor[1] floatValue];
    CGFloat blueDelta = [self.kSelectColor[2] floatValue] - [self.kNormalColor[2] floatValue];
    //NSLog(@"%f,%f,%f",(255.0 - redDelta * progress), 153.0 - greenDelta*progress,0.0 - blueDelta*progress);
    sourceLabel.textColor = [UIColor colorWithRed:([self.kSelectColor[0] floatValue]- redDelta * progress)/255.0 green:([self.kSelectColor[1] floatValue] - greenDelta*progress)/255.0 blue:([self.kSelectColor[2] floatValue] - blueDelta*progress)/255.0 alpha:1.0];
    targetLabel.textColor = [UIColor colorWithRed:([self.kNormalColor[0] floatValue] + redDelta * progress)/255.0 green:([self.kNormalColor[1] floatValue] + greenDelta*progress)/255.0 blue:([self.kNormalColor[2] floatValue] + blueDelta*progress)/255.0 alpha:1.0];

    self.currentIndex = targetIndex;
    self.oldIndex = sourceIndex;
}
- (void)setScrollViewOffSet
{
    UILabel * currentLabel = self.titleLables[self.currentIndex];
    UILabel * oldLabel = self.titleLables[self.oldIndex];
    currentLabel.textColor = self.style.selectedColor;
    if (self.currentIndex != self.oldIndex) {
        oldLabel.textColor = self.style.normalColor;
    }
    
    CGFloat labelCenterX  = currentLabel.center.x;
    CGPoint titleOffSet = self.scrollView.contentOffset;
    titleOffSet.x = labelCenterX - kScreenW * 0.5;
    if(titleOffSet.x < 0)titleOffSet.x = 0;
    // 处理右边最大偏移量
    CGFloat maxOffSet = self.scrollView.contentSize.width - self.scrollView.bounds.size.width;
    if (titleOffSet.x > maxOffSet) titleOffSet.x = maxOffSet;
    // 处理偏移量
    [self.scrollView setContentOffset:titleOffSet animated:YES];
}

@end
