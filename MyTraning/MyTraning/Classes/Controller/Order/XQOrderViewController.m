//
//  XQOrderViewController.m
//  MyTraning
//
//  Created by duxiaoqiang on 2017/7/27.
//  Copyright © 2017年 professional. All rights reserved.
//

#import "XQOrderViewController.h"
#import "UIView+BlankPage.h"
#import "XQLoginViewController.h"
@interface XQOrderViewController ()

@end

@implementation XQOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view showBlankPageWithImageName:@"Prompt_biaoqing1" title:@"登陆后可查看全部订单" btnTitles:@[@"马上登陆"] bottomTipText:nil actionBlock:^(NSInteger btnIndex) {
        XQLoginViewController * loginVC = [[XQLoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
