//
//  XQNavigationController.m
//  MyTraning
//
//  Created by duxiaoqiang on 2017/7/27.
//  Copyright © 2017年 professional. All rights reserved.
//

#import "XQNavigationController.h"
#import "XQLoginViewController.h"
#import "XQBaseViewController.h"
@interface XQNavigationController ()
@property (nonatomic,assign) BOOL isLogin ;
@end

@implementation XQNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isLogin = NO;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{

    if([viewController isKindOfClass:[XQBaseViewController class]])
    {
        if(((XQBaseViewController *)viewController).isCheckLogin)
        {
            if (!self.isLogin) {
                viewController = [[XQLoginViewController alloc] init];
            }
        }
    }
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }else{
        viewController.hidesBottomBarWhenPushed = NO;
    }
    [super pushViewController:viewController animated:animated];
}

@end
