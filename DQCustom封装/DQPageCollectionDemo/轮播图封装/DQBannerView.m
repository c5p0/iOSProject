//
//  DQBannerView.m
//  test
//
//  Created by duxiaoqiang on 2017/4/24.
//  Copyright © 2017年 professional. All rights reserved.
//

#import "DQBannerView.h"
#import "DQBannerCell.h"
//#import "UIImageView+WebCache.h"
#define kMaxRow 10000
@interface DQBannerView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *timer;
@end
static NSString * bannerReuseIdentifier = @"bannerReuseIdentifier";
@implementation DQBannerView

+ (instancetype)bannerView
{
    DQBannerView * bannerView = [[[NSBundle mainBundle] loadNibNamed:@"DQBannerView" owner:nil options:nil] firstObject];
    bannerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100);
    return bannerView;
}

+ (instancetype)bannerView:(CGRect)frame
{
    DQBannerView * bannerView = [[[NSBundle mainBundle] loadNibNamed:@"DQBannerView" owner:nil options:nil] firstObject];
    bannerView.frame = frame;
    return bannerView;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.placeHolderStr = @"";
    // 注册CollectionCell
    [self.collectionView registerNib:[UINib nibWithNibName:@"DQBannerCell" bundle:nil] forCellWithReuseIdentifier:bannerReuseIdentifier];
    self.pageControl.currentPage = 0;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.itemSize = self.bounds.size;
}


- (void)setImageUrlArray:(NSArray *)imageUrlArray
{
    _imageUrlArray = imageUrlArray;
    [self.collectionView reloadData];
    // 设置pageNumber 数量
    self.pageControl.numberOfPages = imageUrlArray.count;
    // 默认滚动到中间位置
    self.collectionView.contentSize = CGSizeMake(kMaxRow * imageUrlArray.count * [UIScreen mainScreen].bounds.size.width, self.bounds.size.height);
    [self.collectionView setContentOffset:CGPointMake([UIScreen mainScreen].bounds.size.width * imageUrlArray.count * kMaxRow / 2, 0) animated:NO];
    [self removeCycleTime];
    [self addCycleTime];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageUrlArray.count * kMaxRow;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DQBannerCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:bannerReuseIdentifier forIndexPath:indexPath];
    NSInteger index = indexPath.row % self.imageUrlArray.count;
    // 判断是否显示标题
    if (self.titlesArray == nil) {
        cell.bannerTitleLabel.hidden = YES;
    }else
    {
        cell.bannerTitleLabel.hidden = NO;
        cell.bannerTitleLabel.text = self.titlesArray[index];
    }
    if (self.type == DQBannerSourceTypeFromLocal) {
        cell.bannerImageView.image = [UIImage imageNamed:self.imageUrlArray[index]];
    }else{
       // [cell.bannerImageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrlArray[index]] placeholderImage:[UIImage imageNamed:self.placeHolderStr]];
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.row % self.imageUrlArray.count;
    if ([self.delegate respondsToSelector:@selector(picSelectedIndex:selectedIndex:)]) {
        [self.delegate picSelectedIndex:self selectedIndex:index];
    }
}

#pragma mark - 对定时器操作
- (void)addCycleTime
{
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(autoScrollNextPage) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

- (void)removeCycleTime
{
    [_timer invalidate];
    _timer = nil;
}
- (void)autoScrollNextPage
{
    //1 : 获取当前滚动的偏移量
    CGFloat currentOffSetX = self.collectionView.contentOffset.x;
    CGFloat offsetX = currentOffSetX + self.collectionView.bounds.size.width;
    [self.collectionView setContentOffset:CGPointMake(offsetX, 0)];
}

#pragma mark - 控制UIScrollView 滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 获取当前偏移量
    CGFloat offsetX = scrollView.contentOffset.x + scrollView.bounds.size.width * 0.5;
    NSInteger totalOffsex = (NSInteger)(offsetX / scrollView.bounds.size.width);
    self.pageControl.currentPage = totalOffsex % (_imageUrlArray.count == 0 ? 1 : _imageUrlArray.count);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeCycleTime];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addCycleTime];
}

@end
