//
//  XQCollectionReusableView.m
//  MyTraning
//
//  Created by duxiaoqiang on 2017/7/26.
//  Copyright © 2017年 professional. All rights reserved.
//

#import "XQCollectionReusableView.h"
#import "DQBannerView.h"
#import "UIView+Extension.h"
#import "XQHomerViewModel.h"
#import "XQBannerModel.h"
#import "XQCustomDefine.h"
#import "XQHomeCollectionViewCell.h"
@interface XQCollectionReusableView()
<
DQBannerViewDelegate,
UICollectionViewDelegate,
UICollectionViewDataSource
>
@property (weak, nonatomic) IBOutlet UIView *bannerView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) DQBannerView *dQBannerView;
@property (nonatomic,strong) NSMutableArray *bannerArray;
@property (nonatomic,strong) NSMutableArray *categoryArray; // 记录主页类别字典

@end
@implementation XQCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupView];
}

/**
 初始化View
 */
- (void)setupView
{
    // 初始化Banner
    [self.bannerView addSubview:self.dQBannerView];
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat margin = 10;
    CGFloat itemWH = (kScrrenW - 4* margin)*0.25;
    CGFloat itemMagin = (kScrrenW - 4 * itemWH) / 5;
    layout.itemSize = CGSizeMake(itemWH, itemWH);
    layout.minimumLineSpacing = margin;
    layout.minimumInteritemSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(margin, itemMagin, 0, itemMagin);
    [self.collectionView setCollectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.scrollsToTop = YES;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XQHomeCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"XQHomeCollectionViewCellID"];
}

#pragma mark - UICollection代理和数据源
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.categoryArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XQHomeCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XQHomeCollectionViewCellID" forIndexPath:indexPath];
    cell.itemDict = self.categoryArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    if (self.ClickCategoryItemBlock) {
        self.ClickCategoryItemBlock(indexPath.row);
    }
}

- (void)setPicImageArray:(NSMutableArray *)picImageArray
{
    _picImageArray = picImageArray;
    self.dQBannerView.imageUrlArray = picImageArray;
}

#pragma mark - Banner点击事件代理
- (void)picSelectedIndex:(DQBannerView *)bannerView selectedIndex:(NSInteger)index
{
    NSLog(@"点击了第几张%zd",index);
}
#pragma mark - lazy
-(DQBannerView* )dQBannerView
{
    if(!_dQBannerView)
    {
        CGRect frame = CGRectMake(0, 0, self.bannerView.width, self.bannerView.height);
        _dQBannerView = [DQBannerView bannerView:frame];
        // 设置占位
        _dQBannerView.placeHolderImage = [UIImage imageNamed:@"bg"];
        _dQBannerView.showPageControl = NO;
        _dQBannerView.type = DQBannerSourceTypeFromURL;
        _dQBannerView.delegate = self;
    }
    return _dQBannerView;
}

#pragma mark - 点击事件
// 简历招聘点击
- (IBAction)recruitClick:(id)sender {
    if (self.RecruitClickBlock) {
        self.RecruitClickBlock();
    }
}

// 在线签约
- (IBAction)signClick:(id)sender {
    if (self.SignClickBlock) {
        self.SignClickBlock();
    }
}
// 薪资支付
- (IBAction)payClick:(id)sender {
    if (self.PayClickBlock) {
        self.PayClickBlock();
    }
}

-(NSMutableArray* )bannerArray
{
    if(!_bannerArray)
    {
        _bannerArray = [NSMutableArray array];
        
    }
    return _bannerArray;
}
-(NSMutableArray* )categoryArray
{
    if(!_categoryArray)
    {
        _categoryArray = [[NSMutableArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Category" ofType:@"plist"]];
    }
    return _categoryArray;
}

@end
