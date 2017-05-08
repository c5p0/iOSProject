//
//  XMGDownLoadListernMainVC.m
//  XMGDownLoadListern
//
//  Created by 王顺子 on 16/11/29.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGDownLoadListernMainVC.h"
#import "XMGSementBarVC.h"


@interface XMGDownLoadListernMainVC ()

@property (nonatomic, weak) XMGSementBarVC *segmentBarVC;

@end

@implementation XMGDownLoadListernMainVC

#pragma mark - 生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpUI];
    [self setUpDataSource];

}

#pragma mark - 懒加载
/** 懒加载分段控制器 */
- (XMGSementBarVC *)segmentBarVC {
    if (!_segmentBarVC) {
        XMGSementBarVC *segmentBarVC = [[XMGSementBarVC alloc] init];
        [self addChildViewController:segmentBarVC];
        _segmentBarVC = segmentBarVC;
    }
    return _segmentBarVC;
}

#pragma mark - 私有方法

/**
 设置UI界面
 */
- (void)setUpUI {
    self.automaticallyAdjustsScrollViewInsets = NO;

    // 1. 设置导航栏背景颜色, 以及titleView内容视图
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar_bg_64"] forBarMetrics:UIBarMetricsDefault];
    self.segmentBarVC.segmentBar.frame = CGRectMake(0, 0, 300, 40);
    self.navigationItem.titleView = self.segmentBarVC.segmentBar;

    // 2. 设置控制器内容视图
    self.segmentBarVC.view.frame = CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height - 60);
    [self.view addSubview:self.segmentBarVC.view];

}

/**
 设置需要展示的数据源
 */
- (void)setUpDataSource {
    UITableViewController *vc1 = [[UITableViewController alloc] init];
    UITableViewController *vc2 = [[UITableViewController alloc] init];
    UITableViewController *vc3 = [[UITableViewController alloc] init];
    [self.segmentBarVC setUpWithItems:@[@"专辑", @"声音", @"下载中"] childVCs:@[vc1, vc2, vc3]];
    
    [self.segmentBarVC.segmentBar updateWithConfig:^(XMGSegmentBarConfig *config) {
        config.segmentBarBackColor = [UIColor whiteColor];
    }];

}


@end
