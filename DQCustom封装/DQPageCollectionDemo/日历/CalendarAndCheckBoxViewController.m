//
//  ViewController.m
//  SecondMenuDemo
//
//  Created by duxiaoqiang on 2017/5/15.
//  Copyright © 2017年 professional. All rights reserved.
//

#import "CalendarAndCheckBoxViewController.h"
#import "CGCustomerSencodMenu.h"
#import "ParentModel.h"
#import "ChildModel.h"
#import "NSDate+Calculate.h"
#import "CGCalendarView.h"

#import "UIImage+Calendar.h"
@interface CalendarAndCheckBoxViewController ()<CGCustomerSencodMenuDataSource,CGCustomerSencodMenuDelegate>
@property (nonatomic,strong) CGCustomerSencodMenu *menuView;
@property (nonatomic,strong) NSMutableArray *parentArray;
@end

@implementation CalendarAndCheckBoxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self testCalendar];
}

- (void)testCalendar
{
    self.view.backgroundColor = [UIColor colorWithRed:235/255.0 green:234/255.0 blue:244/255.0 alpha:1.0];
    //[self.view addSubview:calendarView];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    //    formatter.dateFormat = @"yyyy-MM-dd";
    //    NSDate *newdate = [formatter dateFromString:@"2017-04-05"];
    //    NSLog(@"day = %ld first = %ld",[NSDate totaldaysInMonth:newdate],[NSDate firstWeekdayInThisMonth:newdate]);
    //    UIImageView * iv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 500, 30, 30)];
    //    iv.image = [UIImage drawTriangle:[UIColor redColor] withFrameSize:CGSizeMake(10, 10) withRectSize:CGSizeMake(30, 30)];
    //    [self.view addSubview:iv];
    
    
    
    CGCalendarView * calendarView = [[CGCalendarView alloc] init];
    calendarView.backgroundColor = [UIColor whiteColor];
    calendarView.backShowDate = @"2017-04-06";
    calendarView.selectedItemClick = ^(NSString *selectedDate) {
        NSLog(@"%@",selectedDate);
    };
    [calendarView showView];
}



//***************************************两级菜单测试**************************

- (void)testMenu
{
    // 初始化数据
    [self loadData];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.menuView];
    
    // 创建HeaderView
    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    redView.backgroundColor = [UIColor redColor];
    [self.menuView setTableHeaderView:redView];
    
}

- (void)loadData
{
    ParentModel * p1 = [[ParentModel alloc] init];
    p1.showName = @"开发班";
    p1.uiniqueId = 10;
    
    ParentModel * p2 = [[ParentModel alloc] init];
    p2.showName = @"体育班";
    p2.uiniqueId = 20;
    
    ChildModel * p1_1 = [[ChildModel alloc] init];
    p1_1.showName = @"iOS开发培训";
    p1_1.uiniqueId = 11;
    p1_1.nickName = @"iOS程序员";
    ChildModel * p1_2 = [[ChildModel alloc] init];
    p1_2.showName = @"Android开发培训";
    p1_2.uiniqueId = 12;
    p1_2.nickName = @"Android程序员";
    p1.childs = [[NSArray arrayWithObjects:p1_1,p1_2,nil] mutableCopy];
    
    ChildModel * p2_1 = [[ChildModel alloc] init];
    p2_1.showName = @"篮球训练班";
    p2_1.nickName = @"篮球元动员";
    p2_1.uiniqueId = 21;
    
    ChildModel * p2_2 = [[ChildModel alloc] init];
    p2_2.showName = @"足球训练班";
    p2_1.nickName = @"足球运动员";
    p2_2.uiniqueId = 22;
    
    ChildModel * p2_3 = [[ChildModel alloc] init];
    p2_3.showName = @"羽毛球训练班";
    p2_3.uiniqueId = 23;
    
    ChildModel * p2_4 = [[ChildModel alloc] init];
    p2_4.showName = @"排球训练班";
    p2_4.uiniqueId = 24;
    
    p2.childs = [[NSArray arrayWithObjects:p2_1,p2_2,p2_3,p2_4,nil] mutableCopy];
    
    self.parentArray = [[NSArray arrayWithObjects:p1,p2,nil] mutableCopy];
}
-(CGCustomerSencodMenu* )menuView
{
    if(!_menuView)
    {
        CGRect  rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        _menuView = [[CGCustomerSencodMenu alloc] initWithFrame:rect];
        _menuView.backgroundColor = [UIColor colorWithRed:235/255.0 green:234/255.0 blue:244/255.0 alpha:1.0];
        _menuView.dataSource = self;
        _menuView.delegate = self;
        
    }
    return _menuView;
}

- (NSInteger)numberOfSectionsInMeunView:(UITableView *)tableView
{
    return self.parentArray.count;
}

- (NSInteger)menuView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((ParentModel *)self.parentArray[section]).childs.count;
}

// 一级菜单数据源来源
- (NSArray <id <CGCustomerModelProtocol>>*)menuOfParentModels:(CGCustomerSencodMenu *)menuView
{
    return self.parentArray;
}
// 子菜单数据源
- (NSArray <id <CGCustomerModelProtocol>>*)menuChildModels:(CGCustomerSencodMenu *)menuView section:(NSInteger )section
{
    return ((ParentModel *)self.parentArray[section]).childs;
}
- (void)menuView:(UITableView *)tableView didSelectRow:(NSInteger)uiniqueId
{
    NSLog(@"uniQueID = %ld",uiniqueId);
}

- (void)menuViewOfSelectedData:(CGCustomerSencodMenu *)menuView selectedData:(NSArray *)selectedItemArray
{
    NSLog(@"selectedItemArray = %@",selectedItemArray);
}

@end
