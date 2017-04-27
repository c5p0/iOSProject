//
//  PageViewController.m
//  DQCustom封装
//
//  Created by duxiaoqiang on 2017/4/26.
//  Copyright © 2017年 professional. All rights reserved.
//

#import "PageViewController.h"
#import "DQPageView.h"
#import "DQTitleStyle.h"
#import "DQPageCollectionView.h"
#import "DQPageCollectionLayout.h"
#import "UIColor+Extension.h"
@interface PageViewController ()<DQPageCollectionViewDataSource,DQPageCollectionViewDelegate>

@end

@implementation PageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.

    DQTitleStyle * style = [[DQTitleStyle alloc] init];
    style.defaultCols = 4;
    style.isShowLine = NO;
    style.isScrollEnable = NO;
    DQPageCollectionLayout * layout = [[DQPageCollectionLayout alloc] init];
    layout.minimumLineSpacing = 8;
    layout.minimumInteritemSpacing = 8;
    CGFloat itemMagin = 8;
    layout.sectionInset = UIEdgeInsetsMake(itemMagin, itemMagin, itemMagin, itemMagin);
    
    DQPageCollectionView * pageView = [[DQPageCollectionView alloc] initPageWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 250) titles:@[@"战争",@"爱情",@"喜剧",@"动作"] style:style isTitleInTop:YES layout:layout];
    [pageView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"aa"];
    pageView.delegate = self;
    pageView.dataSource = self;
    pageView.backgroundColor = [UIColor purpleColor];
    [pageView setPageControlColor:[UIColor blackColor] selectedColor:[UIColor redColor] normalColor:nil];
    [pageView setCollectionViewColor:[UIColor grayColor]];
    [self.view addSubview:pageView];
  }


- (NSInteger)numberofSections:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)pageCollectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section ==0) {
        return 39;
    }
    return 31;
}

- (UICollectionViewCell *)pageCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"aa" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor randomColor];
    return cell;
}

- (void)pageCollectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"row =%zd",indexPath.row);
}

// 测试菜单栏
- (void)test
{
    CGRect pageFrame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64);
    NSArray * titles = @[@"全部",@"娱乐",@"游戏",@"电影",@"电视剧",@"言情",@"武侠",@"宫廷剧"];
    NSMutableArray * vcArray = [NSMutableArray array];
    for (int i = 0 ; i< titles.count ; i++) {
        [vcArray addObject:[UIViewController new]];
    }
    DQTitleStyle * style = [[DQTitleStyle alloc] init];
    style.defaultCols = 4;
    style.isShowLine = NO;
    style.titleBgColor = [UIColor purpleColor];
    //    style.isShowLine = NO;
    DQPageView * pageView = [[DQPageView alloc] initPageView:pageFrame titles:titles childVcs:vcArray parentVc:self style:style];
    [self.view addSubview:pageView];

}



@end
