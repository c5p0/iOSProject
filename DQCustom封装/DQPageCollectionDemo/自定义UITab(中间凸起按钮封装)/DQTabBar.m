//
//  DQTabBar.m
//  DQFM
//
//  Created by duxiaoqiang on 2017/4/24.
//  Copyright © 2017年 professional. All rights reserved.
//

#import "DQTabBar.h"
#import "UIView+Extension.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@interface DQTabBar()
/** 发布按钮 */
@property (nonatomic, weak) UIButton *playButton;
@end

@implementation DQTabBar
// 这里可以做一些初始化设置
-(instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self setUpInit];
    }
    return self;
}


- (void)setUpInit {
    
    UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [playButton setBackgroundImage:[UIImage imageNamed:@"tabbar_np_playnon"] forState:UIControlStateNormal];
    [playButton setBackgroundImage:[UIImage imageNamed:@"tabbar_np_playnon"] forState:UIControlStateHighlighted];
    [playButton addTarget:self action:@selector(playClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:playButton];
    self.playButton = playButton;
    // 设置样式, 去除tabbar上面的黑线
    self.barStyle = UIBarStyleBlack;
    
    // 设置tabbar 背景图片
    self.backgroundImage = [UIImage imageNamed:@"tabbar_bg"];
    
    // 添加一个按钮, 准备放在中间
    CGFloat width = 65;
    CGFloat height = 65;
    self.playButton.frame = CGRectMake((kScreenWidth - width) * 0.5, (kScreenHeight - height), width, height);
    
}
-(void)layoutSubviews {
    [super layoutSubviews];
    NSInteger count = self.items.count;
    
    // 1. 遍历所有的子控件
    NSArray *subViews = self.subviews;
    
    // 确定单个控件的大小
    CGFloat btnW = self.bounds.size.width / (count + 1);
    CGFloat btnH = self.bounds.size.height;
    CGFloat btnY = 5;
    NSInteger index = 0;
    for (UIView *subView in subViews) {
        if ([subView isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            if (index == count / 2) {
                index ++;
            }
            
            CGFloat btnX = index * btnW;
            subView.frame = CGRectMake(btnX, btnY, btnW, btnH);
            index ++;
        }
    }
    // 控制中间区域的位置
    self.playButton.centerX = self.frame.size.width * 0.5;
    self.playButton.y = self.height - self.playButton.height;
    
}

// 点击中间的按钮
- (void)playClick
{
    if (self.middleClickBlock) {
        self.middleClickBlock(YES);
    }
}

// 设置点击区域
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    // 设置允许交互的区域
    // 1. 转换点击在tabbar上的坐标点, 到中间按钮上
    CGPoint pointInMiddleBtn = [self convertPoint:point toView:self.playButton];
    
    // 2. 确定中间按钮的圆心
    CGPoint middleBtnCenter = CGPointMake(33, 33);
    
    // 3. 计算点击的位置距离圆心的距离
    CGFloat distance = sqrt(pow(pointInMiddleBtn.x - middleBtnCenter.x, 2) + pow(pointInMiddleBtn.y - middleBtnCenter.y, 2));
    
    // 4. 判定中间按钮区域之外
    if (distance > 33 && pointInMiddleBtn.y < 18) {
        return NO;
    }
    
    return YES;
}

@end
