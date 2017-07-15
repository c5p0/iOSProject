//
//  ViewController.m
//  DQPageCollectionDemo
//
//  Created by duxiaoqiang on 2017/4/26.
//  Copyright © 2017年 professional. All rights reserved.
//

#import "ViewController.h"
#import "UIColor+Extension.h"
#import "DQWaterFallLayout.h"
@interface ViewController ()<UICollectionViewDataSource,DQWaterFallLayoutDataSource>
@property (nonatomic,assign) NSInteger totalCount ;
@end
NSString * cellIndetifer = @"cellIndetifer";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _totalCount = 30;
    DQWaterFallLayout * layout = [[DQWaterFallLayout alloc] init];
    CGFloat itemMagin = 9;
    layout.minimumLineSpacing = itemMagin;
    layout.minimumInteritemSpacing = itemMagin;
    layout.sectionInset = UIEdgeInsetsMake(itemMagin, itemMagin, itemMagin, itemMagin);
    layout.dataSource = self;
    UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellIndetifer];
    

}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  _totalCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIndetifer forIndexPath:indexPath];
    cell.backgroundColor = [UIColor randomColor];
    if (indexPath.row == self.totalCount -1) {
        self.totalCount += 30;
        [collectionView reloadData];
    }
    return cell;
}

- (CGFloat)heightOfDQWaterFallLayout:(DQWaterFallLayout *)layout indexPath:(NSIndexPath *)indexPath
{
    return indexPath.row % 2 == 0 ? self.view.bounds.size.width * 2 / 3 : self.view.bounds.size.width * 0.5;
}

- (NSInteger)numberOfColsDQWaterFallLayout:(DQWaterFallLayout *)layout
{
    return 3;
}
@end
