//
//  UIView+BlankPage.m
//  MyTraning
//
//  Created by duxiaoqiang on 2017/7/27.
//  Copyright © 2017年 professional. All rights reserved.
//

#import "UIView+BlankPage.h"

#import <objc/runtime.h>

static char blankPageBackColorKey;
static char blankPageTopKey;
static char blankImageTopKey;
static char blankPageWidthScaleKey;
static char blankPageDistanceBetweenPicturesAndTextKey;
static char blankPageDistanceBetweenBtnAndBottomTipKey;
static char blankPageBottomTipTextAlignmentKey;
static char blankPageBtnTypeKey;
static char blockKey;


@interface BlankPageBackView : UIView

@end

@implementation UIView (BlankPage)

- (void)showBlankPageWithImageName:(NSString *)imageName
                             title:(NSString *)title
                         btnTitles:(NSArray<NSString *> *)btnTitles
                     bottomTipText:(NSString *)bottomTipText
                       actionBlock:(void (^)(NSInteger))actionBlock
{
    NSTimeInterval time = 0.1f;
    if (self.bounds.size.width == [UIScreen mainScreen].bounds.size.width)
    {
        time = 0.00001f;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (actionBlock)
        {
            objc_setAssociatedObject(self, &blockKey, [actionBlock copy], OBJC_ASSOCIATION_RETAIN);
        }
        
        [self hideBlankPage];
        
        // 底部视图
        BlankPageBackView *backView = [[BlankPageBackView alloc] initWithFrame:CGRectMake(0, self.blankPageTop, self.bounds.size.width, [self isKindOfClass:[UITableView class]] ? self.bounds.size.height : self.bounds.size.height - self.blankPageTop)];
        backView.backgroundColor = self.blankPageBackColor ?: [UIColor colorWithRed:241 / 255. green:240 / 255. blue:245 / 255. alpha:1];
        [self addSubview:backView];
        
        // 顶部图片，按钮背景视图，用于集体移动上下偏移量
        UIView *topBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, backView.bounds.size.width * self.blankPageWidthScale, 20)];
        [backView addSubview:topBackView];
        
        // 图片
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(topBackView.bounds.size.width * 0.25, 0, topBackView.bounds.size.width * 0.5, topBackView.bounds.size.width * 0.5)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageNamed:imageName];
        [topBackView addSubview:imageView];
        
        CGFloat topH = CGRectGetMaxY(imageView.frame);
        
        // 标题
        if (title)
        {
            UILabel *description = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame) + self.blankPageDistanceBetweenPicturesAndText, topBackView.bounds.size.width, 10)];
            description.text = title;
            description.textColor = [UIColor grayColor];
            description.font = [UIFont systemFontOfSize:14];
            description.textAlignment = NSTextAlignmentCenter;
            description.numberOfLines = 2;
            [description sizeToFit];
            description.center = CGPointMake(topBackView.bounds.size.width / 2, description.frame.origin.y + description.bounds.size.height / 2);
            [topBackView addSubview:description];
            
            topH = CGRectGetMaxY(description.frame);
        }
        
        UIColor *yellow = [UIColor colorWithRed:92 / 255. green:184 / 255. blue:52 / 255. alpha:1];
        
        NSInteger index = 0;
        for (NSString *btnTitle in btnTitles)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            button.frame = CGRectMake(0, index == 0 ? topH + 25. : topH + 15, topBackView.bounds.size.width, 30);
            button.layer.cornerRadius = 4;
            button.layer.masksToBounds = YES;
            button.titleLabel.font = [UIFont fontWithName:@"Courier New" size:16];
            [button setTitle:btnTitle forState:UIControlStateNormal];
            button.tag = 6378 + index;
            [button addTarget:self action:@selector(blankPageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            
            if (self.blankPageBtnType == 0)
            {
                button.backgroundColor = yellow;
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
            else
            {
                button.backgroundColor = [UIColor whiteColor];
                button.layer.borderColor = yellow.CGColor;
                button.layer.borderWidth = 0.5;
                [button setTitleColor:yellow forState:UIControlStateNormal];
            }
            
            [topBackView addSubview:button];
            
            topH = CGRectGetMaxY(button.frame);
            
            index ++;
        }
        
        topBackView.frame = CGRectMake(0, 0, topBackView.bounds.size.width, topH);
        topBackView.center = CGPointMake(backView.bounds.size.width / 2, backView.bounds.size.height / 2 + self.blankImageTop);
        
        if (bottomTipText)
        {
            // 底部提示信息
            UILabel *tip = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(topBackView.frame) + self.blankPageDistanceBetweenBtnAndBottomTip, backView.bounds.size.width - 40, 20)];
            tip.textColor = [UIColor grayColor];
            tip.font = [UIFont systemFontOfSize:14];
            tip.numberOfLines = 0;
            
            // 设置行间距
            NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:bottomTipText];
            NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle1 setLineSpacing:6];
            [paragraphStyle1 setAlignment:self.blankPageBottomTipTextAlignment];
            [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [bottomTipText length])];
            
            [tip setAttributedText:attributedString1];
            
            [tip sizeToFit];
            // 最大允许高度
            CGFloat max = backView.bounds.size.height - CGRectGetMinY(tip.frame) - 5;
            tip.frame = CGRectMake(tip.frame.origin.x, tip.frame.origin.y, backView.bounds.size.width - 40, tip.bounds.size.height > max ? max : tip.bounds.size.height);
            
            [backView addSubview:tip];
        }
    });
}

- (void)hideBlankPage
{
    for (UIView *view in self.subviews)
    {
        if ([view isKindOfClass:[BlankPageBackView class]])
        {
            view.hidden = YES;
            [view removeFromSuperview];
            return;
        }
    }
}

- (void)blankPageBtnAction:(UIButton *)btn
{
    void (^block)(NSInteger index) = objc_getAssociatedObject(self, &blockKey);
    
    if (block)
    {
        block(btn.tag - 6378);
    }
}

#pragma mark -
#pragma mark - setter   getter
- (void)setBlankPageTop:(CGFloat)blankPageTop
{
    [self willChangeValueForKey:@"blankPageTop"];
    objc_setAssociatedObject(self, &blankPageTopKey, @(blankPageTop), OBJC_ASSOCIATION_RETAIN);
    [self didChangeValueForKey:@"blankPageTop"];
}

- (CGFloat)blankPageTop
{
    return [objc_getAssociatedObject(self, &blankPageTopKey) floatValue];
}

- (void)setBlankImageTop:(CGFloat)blankImageTop
{
    [self willChangeValueForKey:@"blankImageTop"];
    objc_setAssociatedObject(self, &blankImageTopKey, @(blankImageTop), OBJC_ASSOCIATION_RETAIN);
    [self didChangeValueForKey:@"blankImageTop"];
}

- (CGFloat)blankImageTop
{
    return [objc_getAssociatedObject(self, &blankImageTopKey) floatValue];
}

- (void)setBlankPageWidthScale:(CGFloat)blankPageWidthScale
{
    [self willChangeValueForKey:@"blankPageWidthScale"];
    objc_setAssociatedObject(self, &blankPageWidthScaleKey, @(blankPageWidthScale), OBJC_ASSOCIATION_RETAIN);
    [self didChangeValueForKey:@"blankPageWidthScale"];
}

- (CGFloat)blankPageWidthScale
{
    CGFloat scale = [objc_getAssociatedObject(self, &blankPageWidthScaleKey) floatValue];
    
    if (scale > 1 || scale <= 0)
    {
        return 0.6;
    }
    
    return scale;
}

- (void)setBlankPageBackColor:(UIColor *)blankPageBackColor
{
    [self willChangeValueForKey:@"blankPageBackColor"];
    objc_setAssociatedObject(self, &blankPageBackColorKey, blankPageBackColor, OBJC_ASSOCIATION_RETAIN);
    [self didChangeValueForKey:@"blankPageBackColor"];
}

- (UIColor *)blankPageBackColor
{
    return objc_getAssociatedObject(self, &blankPageBackColorKey);
}

- (void)setBlankPageDistanceBetweenPicturesAndText:(CGFloat)blankPageDistanceBetweenPicturesAndText
{
    [self willChangeValueForKey:@"blankPageDistanceBetweenPicturesAndText"];
    objc_setAssociatedObject(self, &blankPageDistanceBetweenPicturesAndTextKey, @(blankPageDistanceBetweenPicturesAndText), OBJC_ASSOCIATION_RETAIN);
    [self didChangeValueForKey:@"blankPageDistanceBetweenPicturesAndText"];
}

- (CGFloat)blankPageDistanceBetweenPicturesAndText
{
    return [objc_getAssociatedObject(self, &blankPageDistanceBetweenPicturesAndTextKey) floatValue] > 0 ? [objc_getAssociatedObject(self, &blankPageDistanceBetweenPicturesAndTextKey) floatValue] : 20.f;
}

- (void)setBlankPageDistanceBetweenBtnAndBottomTip:(CGFloat)blankPageDistanceBetweenBtnAndBottomTip
{
    [self willChangeValueForKey:@"blankPageDistanceBetweenBtnAndBottomTip"];
    objc_setAssociatedObject(self, &blankPageDistanceBetweenBtnAndBottomTipKey, @(blankPageDistanceBetweenBtnAndBottomTip), OBJC_ASSOCIATION_RETAIN);
    [self didChangeValueForKey:@"blankPageDistanceBetweenBtnAndBottomTip"];
}

- (CGFloat)blankPageDistanceBetweenBtnAndBottomTip
{
    return [objc_getAssociatedObject(self, &blankPageDistanceBetweenBtnAndBottomTipKey) floatValue] > 0 ? [objc_getAssociatedObject(self, &blankPageDistanceBetweenBtnAndBottomTipKey) floatValue] : 20.f;
}

- (void)setBlankPageBottomTipTextAlignment:(NSTextAlignment)blankPageBottomTipTextAlignment
{
    [self willChangeValueForKey:@"blankPageBottomTipTextAlignment"];
    objc_setAssociatedObject(self, &blankPageBottomTipTextAlignmentKey, @(blankPageBottomTipTextAlignment), OBJC_ASSOCIATION_RETAIN);
    [self didChangeValueForKey:@"blankPageBottomTipTextAlignment"];
}

- (NSTextAlignment)blankPageBottomTipTextAlignment
{
    id number = objc_getAssociatedObject(self, &blankPageBottomTipTextAlignmentKey);
    if (number)
    {
        return [objc_getAssociatedObject(self, &blankPageBottomTipTextAlignmentKey) integerValue];
    }
    else
    {
        return NSTextAlignmentCenter;
    }
}

- (void)setBlankPageBtnType:(NSInteger)blankPageBtnType
{
    [self willChangeValueForKey:@"blankPageBtnType"];
    objc_setAssociatedObject(self, &blankPageBtnTypeKey, @(blankPageBtnType), OBJC_ASSOCIATION_RETAIN);
    [self didChangeValueForKey:@"blankPageBtnType"];
}

- (NSInteger)blankPageBtnType
{
    return [objc_getAssociatedObject(self, &blankPageBtnTypeKey) integerValue];
}

@end
@implementation BlankPageBackView

@end
