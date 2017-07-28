//
//  XQMainViewController.m
//  MyTraning
//
//  Created by duxiaoqiang on 2017/7/25.
//  Copyright © 2017年 professional. All rights reserved.
//

#import "XQMainViewController.h"
#import "XQCustomDefine.h"
@interface XQMainViewController ()

@end

@implementation XQMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tabBar.backgroundImage = [UIImage imageNamed:@"dibu"];
    
    [self addChildController:@"Home"];
    [self addChildController:@"Recruitment"];
    [self addChildController:@"Order"];
    [self addChildController:@"Profile"];
}

- (void)addChildController:(NSString *)storyName
{
    UIViewController * vc  = UIStoryboardGetInstantiateInitialController(storyName);
    // 设置UITabBarItem图片偏移量
    vc.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    [self addChildViewController:vc];
}

@end
