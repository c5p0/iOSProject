//
//  DQTabBarController.m
//  DQFM
//
//  Created by duxiaoqiang on 2017/4/24.
//  Copyright © 2017年 professional. All rights reserved.
//

#import "DQTabBarController.h"
#import "DQNavigationController.h"
#import "DQTabBar.h"
@interface DQTabBarController ()

@end

@implementation DQTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [UINavigationBar appearance];
    
    // 通过appearance统一设置所有UITabBarItem的文字属性
    // 后面带有UI_APPEARANCE_SELECTOR的方法, 都可以通过appearance对象来统一设置
    //    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    //    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    //    attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    //
    //    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    //    selectedAttrs[NSFontAttributeName] = attrs[NSFontAttributeName];
   //    selectedAttrs[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
   //
   //    UITabBarItem *item = [UITabBarItem appearance];
   //    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
   //    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
    // 添加子控制器
    [self setupChildVc:[[UIViewController alloc] init] title:@"" image:@"tabbar_find_n" selectedImage:@"tabbar_find_h" isRequiredNavController:YES];
    
    [self setupChildVc:[[UIViewController alloc] init] title:@"" image:@"tabbar_sound_n" selectedImage:@"tabbar_sound_h"
     isRequiredNavController:YES];
    
    [self setupChildVc:[[UIViewController alloc] init] title:@"" image:@"tabbar_download_n" selectedImage:@"tabbar_download_h" isRequiredNavController:YES];
    
    [self setupChildVc:[[UIViewController alloc] init] title:@"" image:@"tabbar_me_n" selectedImage:@"tabbar_me_h" isRequiredNavController:YES];
    
    // 更换tabBar
    [self setValue:[[DQTabBar alloc] init] forKeyPath:@"tabBar"];

}

/**
 * 初始化子控制器
 */
- (void)setupChildVc:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage isRequiredNavController:(BOOL)isRequred
{
    // 设置文字和图片
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:image];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    vc.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(100)/100.0 green:arc4random_uniform(100)/100.0 blue:arc4random_uniform(100)/100.0 alpha:1.0];
    if (isRequred) {
        // 添加一层导航控制器
        DQNavigationController * nav = [[DQNavigationController alloc] initWithRootViewController:vc];
        [self addChildViewController:nav];
        
    }else
    {
        // 添加为子控制器
        [self addChildViewController:vc];
    }
 
}

@end
