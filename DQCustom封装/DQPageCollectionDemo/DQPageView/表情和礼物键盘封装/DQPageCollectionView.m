//
//  DQPageCollectionView.m
//  DQCustom封装
//  表情键盘的封装
//  Created by duxiaoqiang on 2017/4/27.
//  Copyright © 2017年 professional. All rights reserved.
//

#import "DQPageCollectionView.h"
#import "DQPageCollectionLayout.h"
#import "DQTitleStyle.h"
#import "DQPageTitleView.h"
@interface DQPageCollectionView()<UICollectionViewDelegate,UICollectionViewDataSource,DQPageTitleViewDelegate>
@property (nonatomic,strong) NSArray *titles;
@property (nonatomic,strong) DQTitleStyle *style;
@property (nonatomic,assign) BOOL  isTitleInTop;
@property (nonatomic,strong) DQPageTitleView * titleView ;
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,strong) UICollectionView * collectionView ;
@property (nonatomic,strong) DQPageCollectionLayout *layout;
@property (nonatomic,strong) NSIndexPath * sourceIndexPath;
@end
@implementation DQPageCollectionView

- (instancetype)initPageWithFrame:(CGRect)frame titles:(NSArray *)titles style:(DQTitleStyle *)style isTitleInTop:(BOOL)isTitleInTop layout:(DQPageCollectionLayout *)layout
{
    if (self = [super init]) {
        self.frame = frame;
        self.titles = titles;
        self.style = style;
        self.isTitleInTop = isTitleInTop;
        self.layout = layout;
        self.sourceIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    // 1: 创建标题
    CGFloat titleH = 44;
    CGFloat titleY = self.isTitleInTop ? 0 : (self.frame.size.height - titleH);
    CGRect  titleFrame = CGRectMake(0, titleY, self.frame.size.width, titleH);
    self.titleView = [[DQPageTitleView alloc] initPageTitle:self.titles withFrame:titleFrame style:self.style];
    self.titleView.delegate = self;
    [self addSubview:self.titleView];
    // 2：创建pageControl
    CGFloat pageControlH = 20;
    CGFloat pageControlY = self.isTitleInTop ? (self.frame.size.height - pageControlH) : (self.frame.size.height - titleH - pageControlH);
    CGRect  pageControlFrame = CGRectMake(0, pageControlY, self.frame.size.width, pageControlH);
    self.pageControl = [[UIPageControl alloc] initWithFrame:pageControlFrame];
    self.pageControl.numberOfPages = 4;
    self.pageControl.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
    [self addSubview:self.pageControl];
    // 添加中间内容
    
    CGFloat collectionY = self.isTitleInTop ? titleH : 0;
    CGRect collectionViewFrame = CGRectMake(0, collectionY, self.frame.size.width, self.frame.size.height - titleH - pageControlH);
    self.collectionView = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:self.layout];
    self.collectionView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = YES;
    [self addSubview:self.collectionView];
    
}
- (void)reload
{
    [self.collectionView reloadData];
}
- (void)registerClass:(Class)registerClass forCellWithReuseIdentifier:(NSString *)identifier
{
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:identifier];
}

- (void)registerNib:(UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier
{
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:identifier];
}

- (void)setPageControlColor:(UIColor *)bgColor selectedColor:(UIColor *)selectedColor normalColor:(UIColor *)normalColor
{
    if (bgColor) {
        self.pageControl.backgroundColor = bgColor;
    }
    if (selectedColor) {
        [self.pageControl setCurrentPageIndicatorTintColor:selectedColor];
    }
    if (normalColor) {
        [self.pageControl setPageIndicatorTintColor:normalColor];
    }
}

- (void)setCollectionViewColor:(UIColor *)bgColor
{
    if (bgColor) {
        self.collectionView.backgroundColor = bgColor;
    }
}
#pragma mark - collection的数据源和代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSInteger sections = 0;
    if([self.dataSource respondsToSelector:@selector(numberofSections:)])
    {
        sections = [self.dataSource numberofSections:collectionView];
    }
    return sections;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger rowOfSection = 0;
    if ([self.dataSource respondsToSelector:@selector(pageCollectionView:numberOfItemsInSection:)]) {
        rowOfSection = [self.dataSource pageCollectionView:collectionView numberOfItemsInSection:section];
    }
    if (section == 0) {
        // 计算当前页有多少Page
        NSInteger numPage = (rowOfSection - 1)/(self.layout.cols * self.layout.rows) + 1;
        self.pageControl.numberOfPages = numPage;
    }
    return rowOfSection;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataSource respondsToSelector:@selector(pageCollectionView:cellForItemAtIndexPath:)]) {
        return [self.dataSource pageCollectionView:collectionView cellForItemAtIndexPath:indexPath];
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(pageCollectionView:didSelectItemAtIndexPath:)]) {
        [self.delegate pageCollectionView:collectionView didSelectItemAtIndexPath:indexPath];
    }
}

#pragma mark - UIScrollView 代理
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self collectionScrollDid];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self collectionScrollDid];
    }
    
}

- (void)collectionScrollDid
{
    // 获取该页第一个cell
    CGFloat offsetX = self.collectionView.contentOffset.x;
    NSIndexPath *targetIndex = [self.collectionView indexPathForItemAtPoint:CGPointMake(offsetX + self.layout.sectionInset.left+1, self.layout.sectionInset.top +1)];
    
    
    // 判断Section是否发生改变
    if (self.sourceIndexPath.section != targetIndex.section) {
        [self.titleView setCurrentIndex:1.0 sourceIndex:self.sourceIndexPath.section targetIndex:targetIndex.section];
        self.sourceIndexPath = targetIndex;
        NSInteger numOfSection = 0;
        if ([self.dataSource respondsToSelector:@selector(pageCollectionView:numberOfItemsInSection:)]) {
            numOfSection = [self.dataSource pageCollectionView:self.collectionView numberOfItemsInSection:targetIndex.section ?: 0];
        }
        NSInteger numOfPage = (numOfSection - 1) / (self.layout.cols * self.layout.rows) + 1;
        self.pageControl.numberOfPages = numOfPage;
    }
    self.pageControl.currentPage = targetIndex.row / (self.layout.cols * self.layout.rows);
}

- (void)pageTitleView:(DQPageTitleView *)pageTitleView selectedIndex:(NSInteger)index
{
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:index];
    
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    CGPoint offSet = self.collectionView.contentOffset;
    offSet.x -=  self.layout.sectionInset.left;
    self.collectionView.contentOffset = offSet;
    
    NSInteger numOfSection = 0;
    if ([self.dataSource respondsToSelector:@selector(pageCollectionView:numberOfItemsInSection:)]) {
        numOfSection = [self.dataSource pageCollectionView:self.collectionView numberOfItemsInSection:indexPath.section ?: 0];
    }
    NSInteger numOfPage = (numOfSection - 1) / (self.layout.cols * self.layout.rows) + 1;
    self.pageControl.numberOfPages = numOfPage;
    self.pageControl.currentPage = 0;
    self.sourceIndexPath = indexPath;
    
}

@end
