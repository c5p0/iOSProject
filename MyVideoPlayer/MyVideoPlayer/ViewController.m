//
//  ViewController.m
//  MyVideoPlayer
//
//  Created by duxiaoqiang on 2017/7/19.
//  Copyright © 2017年 professional. All rights reserved.
//

#import "ViewController.h"
#import "VideoListCell.h"
#import "PlayVideoViewController.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView.rowHeight = 65;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VideoListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"VideoListCell" forIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self performSegueWithIdentifier:@"PlayVideoViewController" sender:nil];
}

@end
