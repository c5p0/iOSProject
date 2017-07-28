//
//  XQHomeViewController.m
//  MyTraning
//
//  Created by duxiaoqiang on 2017/7/25.
//  Copyright © 2017年 professional. All rights reserved.
//

#import "XQHomeViewController.h"
#import "XQHomerViewModel.h"
#import "XQCustomDefine.h"
#import "XQCollectionReusableView.h"
#import "XQBannerModel.h"

@interface XQHomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *bannerArray;
@property (nonatomic,strong) NSArray *itemArray;
@property (nonatomic,assign) CGSize itemSize ;
@end

@implementation XQHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupData];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)setupUI
{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat margin = 10;
    CGFloat itemWH = (kScrrenW - 3* margin)*0.5;
    self.itemSize = CGSizeMake(itemWH, 75);
    layout.itemSize =  self.itemSize;
    layout.minimumLineSpacing = margin;
    layout.minimumInteritemSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(margin, margin, 0, margin);
    [self.collectionView setCollectionViewLayout:layout];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"ItemCellId"];
    // 注册CollectionHeaderView
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XQCollectionReusableView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ItemHeaderViewCellId"];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.itemArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ItemCellId" forIndexPath:indexPath];
    CGRect frame = CGRectMake(0, 0, self.itemSize.width, self.itemSize.height);
    UIImageView * iv = [[UIImageView alloc] initWithFrame:frame];
    iv.image = [UIImage imageNamed:self.itemArray[indexPath.row]];
    cell.backgroundView = iv;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        XQCollectionReusableView *newReusableView  = (XQCollectionReusableView *) [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ItemHeaderViewCellId" forIndexPath:indexPath];
        newReusableView.picImageArray = self.bannerArray;
        __weak typeof(self) wakeSelf = self;
        // 点击Item
        newReusableView.ClickCategoryItemBlock = ^(NSInteger itemTag) {
            [wakeSelf gotoCategoryItem:itemTag];
        };
        // 点击招聘跳转
        newReusableView.RecruitClickBlock = ^{
            [wakeSelf gotoRecruitVC];
        };
        // 点击在线签约
        newReusableView.SignClickBlock = ^{
            [wakeSelf gotoSignVC];
        };
        // 点击薪资支付
        newReusableView.PayClickBlock = ^{
            [wakeSelf gotoPayVC];
        };
        reusableView = newReusableView;
    }
    return reusableView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(kScrrenW,350);
}

#pragma mark - 处理跳转
- (void)gotoCategoryItem:(NSInteger) tag
{
    NSLog(@"tag %zd",tag);
    if (tag == XQCategoryTypeYueSao) { // 月嫂
        
    }else if(tag == XQCategoryTypeYuEr){ // 育儿嫂
    
    }else if(tag == XQCategoryTypeBuZhuJiaBaoMu) // 不住家保姆
    {
    
    }else if(tag == XQCategoryTypeZhuJiaBaoMu) // 住家保姆
    {
        
    }else if(tag == XQCategoryTypePeiHuLaoRen) // 老人陪护
    {
        
    }else if(tag == XQCategoryTypePeoHuBingRen) // 病患陪护
    {
        
    }else if(tag == XQCategoryTypeLongXiaoShiGong) // 长期小时工
    {
        
    }else if(tag == XQCategoryTypeXiaoShiGong) // 小时工
    {
        
    }
}
- (void)gotoRecruitVC
{
    NSLog(@"gotoRecruitVC");
}
- (void)gotoSignVC
{
    NSLog(@"gotoSignVC");
}
- (void)gotoPayVC
{
    NSLog(@"gotoPayVC");
}
#pragma mark - 获取网络数据
- (void)setupData
{
    [self loadBannerData];
}

- (void)loadBannerData
{
    __weak typeof(self) wakeSelf = self;
    [XQHomerViewModel featchBannerData:^(NSArray *result, NSError *error) {
        if (result) {
            [wakeSelf.bannerArray removeAllObjects];
            NSMutableArray * imageArray = [NSMutableArray array];
            for (XQBannerModel *model  in result) {
                [imageArray addObject:model.picurl];
            }
            [wakeSelf.bannerArray addObjectsFromArray:imageArray];
            [wakeSelf.collectionView reloadData];
        }
    }];
}

-(NSMutableArray* )bannerArray
{
    if(!_bannerArray)
    {
        _bannerArray = [NSMutableArray array];
    }
    return _bannerArray;
}

-(NSArray* )itemArray
{
    if(!_itemArray)
    {
        _itemArray = @[@"homevip",@"homesidan",@"homeyuesaotaocan",@"homexuanren"];
    }
    return _itemArray;
}

@end
