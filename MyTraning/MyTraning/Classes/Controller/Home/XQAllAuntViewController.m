//
//  XQAllAuntViewController.m
//  MyTraning
//
//  Created by duxiaoqiang on 2017/7/28.
//  Copyright © 2017年 professional. All rights reserved.
//

#import "XQAllAuntViewController.h"
#import "XQHomerViewModel.h"
@interface XQAllAuntViewController ()

@end

@implementation XQAllAuntViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"全部阿姨";
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSString * token  = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    [XQHomerViewModel loginTest:@"18784406551" token:token block:^(NSDictionary *result, NSError *error) {
        
    }];
}

@end
