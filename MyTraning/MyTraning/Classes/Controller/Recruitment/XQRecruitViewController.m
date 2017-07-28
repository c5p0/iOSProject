//
//  XQRecruitViewController.m
//  MyTraning
//
//  Created by duxiaoqiang on 2017/7/27.
//  Copyright © 2017年 professional. All rights reserved.
//

#import "XQRecruitViewController.h"
#import "XQRecruitCell.h"
#import "XQAllAuntViewController.h"
@interface XQRecruitViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *recruitItemArray;
@end

@implementation XQRecruitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.rowHeight = 60;
    self.automaticallyAdjustsScrollViewInsets = NO;
}


#pragma mark - UITableView 代理和数据
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.recruitItemArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XQRecruitCell * cell = [tableView dequeueReusableCellWithIdentifier:@"XQRecruitCellId" forIndexPath:indexPath];
    cell.itemDict = self.recruitItemArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    XQAllAuntViewController * aunt = [[XQAllAuntViewController alloc] init];
    aunt.isCheckLogin = NO;
    [self.navigationController pushViewController:aunt animated:YES];
}


// 在线签约
- (IBAction)signClick:(id)sender {
}

// 月嫂私单
- (IBAction)yuesaoOrderClick:(id)sender {
}


-(NSMutableArray* )recruitItemArray
{
    if(!_recruitItemArray)
    {
        _recruitItemArray = [[NSMutableArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Recruititem" ofType:@"plist"]];
    }
    return _recruitItemArray;
}
@end
