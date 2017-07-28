//
//  XQBaseViewController.m
//  MyTraning
//
//  Created by duxiaoqiang on 2017/7/27.
//  Copyright © 2017年 professional. All rights reserved.
//

#import "XQBaseViewController.h"
#import "XQCustomDefine.h"
@interface XQBaseViewController ()
@end

@implementation XQBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置导航栏左边返回按钮
    [self setBaseNavLeftButton];
    // 设置导航栏右边的按钮
    [self setBaseNavRightButton];
    
}

- (void)setBaseNavLeftButton
{
    UIImage *tBackImage = [UIImage imageNamed:@"fanhui"];
    UIView *tBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 75, 44)];
    self.backBtnItem = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtnItem.frame = CGRectMake(0, 0, CGRectGetWidth(tBackView.bounds), CGRectGetHeight(tBackView.bounds));
    self.backBtnItem.exclusiveTouch = YES;
    [self.backBtnItem setImage:tBackImage forState:UIControlStateNormal];
    [self.backBtnItem setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self.backBtnItem addTarget:self action:@selector(navBarButtonItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [tBackView addSubview:self.backBtnItem];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:tBackView];

}

- (void)setBaseNavRightButton
{
    self.rightBtnItem = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightBtnItem.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.rightBtnItem.frame = CGRectMake(0, 0, CGRectGetWidth(self.backBtnItem.bounds), CGRectGetHeight(self.backBtnItem.bounds));
    //self.rightBtnItem.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.rightBtnItem.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    self.rightBtnItem.exclusiveTouch = YES;
    UIImage *tOpacityImage = [UIImage imageNamed:@""];
    [self.rightBtnItem setBackgroundImage:tOpacityImage forState:UIControlStateHighlighted];
    [self.rightBtnItem addTarget:self action:@selector(navBarButtonItemAction:) forControlEvents:
     UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightBtnItem];
    self.useGrayItem = NO;
}


- (void)navBarButtonItemAction:(id)sender
{
    //[self dimissAllActivityIndicator];
    
    if ([sender isEqual:self.backBtnItem] && !self.backBtnItem.isSelected)
    {
        self.backBtnItem.selected = YES;
        UINavigationController *vc = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        // 是否是Presented
        if (vc.presentedViewController)
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else
    {
        if (([self.rightBtnItem titleForState:UIControlStateSelected] && ![[self.rightBtnItem titleForState:UIControlStateSelected]isEqualToString:@""]) || [self.rightBtnItem imageForState:UIControlStateSelected])
        {
            self.rightBtnItem.selected = !self.rightBtnItem.isSelected;
        }
    }
}


- (void)setUseGrayItem:(BOOL)theUseGrayItem
{
    _useGrayItem = theUseGrayItem;
    
    if (theUseGrayItem)
    {
        [self.rightBtnItem setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.rightBtnItem setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        
        self.rightBtnItem.userInteractionEnabled = NO;
    }
    else
    {
        [self.rightBtnItem setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
        [self.rightBtnItem setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        
        self.rightBtnItem.userInteractionEnabled = YES;
    }
}

- (BOOL)isUseGrayItem
{
    return _useGrayItem;
}

- (void)setUseBackItem:(BOOL)theUseLeftItem
{
    if (!theUseLeftItem)
    {
        [self.backBtnItem setTitle:@"" forState:UIControlStateNormal];
        
        [self.backBtnItem setImage:nil forState:UIControlStateNormal];
        self.backBtnItem.enabled = NO;
    }
    else
    {
        if (!self.backBtnItem)
        {
            self.backBtnItem = [UIButton buttonWithType:UIButtonTypeCustom];
            self.backBtnItem.frame = CGRectMake(0, 0, 45.0f, 40.0f);
            [self.backBtnItem setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
            [self.backBtnItem addTarget:self action:@selector(navBarButtonItemAction:) forControlEvents:UIControlEventTouchUpInside];
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.backBtnItem];
        }
        else
        {
            self.backBtnItem.enabled = YES;
        }
    }
}

- (void)setRightItemTitle:(NSString *)theRightItemTitle
{
    [self.rightBtnItem setAttributedTitle:nil forState:UIControlStateNormal];
    
    if (theRightItemTitle)
    {
        if (!self.useGrayItem)
        {
            self.useRightItem = YES;
        }
        [self.rightBtnItem setAttributedTitle:nil forState:UIControlStateNormal];
        [self.rightBtnItem setTitle:theRightItemTitle forState:UIControlStateNormal];
        [self.rightBtnItem setTitle:theRightItemTitle forState:UIControlStateHighlighted];
        [self.rightBtnItem setTitle:@"" forState:UIControlStateSelected];
        [self.rightBtnItem setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
        [self.rightBtnItem setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    }
    else
    {
        [self.rightBtnItem setTitle:@"" forState:UIControlStateNormal];
        [self.rightBtnItem setTitle:@"" forState:UIControlStateHighlighted];
    }
    
    self.rightItemTitle = theRightItemTitle;
}

- (void)setBackItemImage:(UIImage *)backItemImage
{
    _backItemImage = backItemImage;
    
    [self.backBtnItem setImage:backItemImage forState:UIControlStateNormal];
}

- (void)setRightItemImage:(UIImage *)theRightItemImage
{
    if (!self.isUseRightItem)
    {
        self.useRightItem = YES;
    }
    CGSize imgSize = theRightItemImage.size;
    CGFloat ratio = imgSize.width / imgSize.height;
    if (imgSize.width > CGRectGetWidth(self.rightBtnItem.frame) || imgSize.height > CGRectGetWidth(self.rightBtnItem.frame)) {
        
        CGRect newFrame = self.rightBtnItem.frame;
        CGFloat newWidth = CGRectGetHeight(self.rightBtnItem.bounds) * ratio;
        newFrame = CGRectMake(CGRectGetMaxX(newFrame) - newWidth, newFrame.origin.y, newWidth, newFrame.size.height);
        self.rightBtnItem.frame = newFrame;
        self.rightBtnItem.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    
    [self.rightBtnItem setImage:theRightItemImage forState:UIControlStateNormal];
    self.rightItemImage = theRightItemImage;
}


@end
