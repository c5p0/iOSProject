//
//  DQPageContentView.m
//  CGNewsDemo
//
//  Created by duxiaoqiang on 17/3/22.
//  Copyright © 2017年 professional. All rights reserved.
//

#import "DQPageContentView.h"

@interface DQPageContentView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) NSArray *childVcs;
@property (nonatomic,strong) UICollectionView *collectionView;
/** 禁止滚动的标识*/
@property (nonatomic,assign) BOOL forbidScrollFlag;
/** 记录开始滚动偏移量*/
@property (nonatomic,assign) CGFloat startOffSetX ;
@end
@implementation DQPageContentView

- (instancetype)initPageContent:(NSArray *)childVcs withFrame:(CGRect)frame
{
    self.childVcs = childVcs;
    return [self initWithFrame:frame];
    
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = self.bounds.size;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.collectionView setPagingEnabled:YES];
    self.collectionView.bounces = NO;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[UICollectionViewCell self] forCellWithReuseIdentifier:@"coontentCellId"];
    [self addSubview:self.collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.childVcs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"coontentCellId" forIndexPath:indexPath];
    for (UIView *view in  cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    UIViewController * vc = self.childVcs[indexPath.row];
    [cell.contentView addSubview:vc.view];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.forbidScrollFlag)return;
    // 当前偏移量
    CGFloat currentOffSetX = scrollView.contentOffset.x;
    // 原始位置角标
    NSInteger sourceIndex = 0;
    // 目标位置角度
    NSInteger targetIndex = 0;
    // 滑动进度
    CGFloat progress = 0;
    CGFloat scrollViewW = scrollView.bounds.size.width;
    // 左滑
    if(currentOffSetX > self.startOffSetX){
        sourceIndex = currentOffSetX / scrollViewW;
        targetIndex = sourceIndex + 1;
        
        if(targetIndex >= self.childVcs.count){
            targetIndex = self.childVcs.count - 1;
        }
        CGFloat ratio = currentOffSetX / scrollViewW;
        progress = ratio - floor(ratio);
        if (currentOffSetX - self.startOffSetX == scrollViewW){
            progress = 1.0;
            targetIndex = sourceIndex;
        }
    }else { // 右滑
        targetIndex = currentOffSetX / scrollViewW;
        sourceIndex = targetIndex + 1;
        if (sourceIndex >= self.childVcs.count){
            sourceIndex = self.childVcs.count - 1;
        }
        CGFloat ratio = currentOffSetX / scrollViewW;
        progress = 1.0 - (ratio - floor(ratio));
    }

    if ([self.delegate respondsToSelector:@selector(pageContentView:progress:sourceIndex:targetIndex:)]) {
        [self.delegate pageContentView:self progress:progress sourceIndex:sourceIndex targetIndex:targetIndex];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.startOffSetX = scrollView.contentOffset.x;
    self.forbidScrollFlag = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(contentViewEndScroll:)]) {
        [self.delegate contentViewEndScroll:self];
    }
}

// 设置pageContentOffSet
- (void)setPageContentOffSet:(NSInteger)index
{
    self.forbidScrollFlag = YES;
    CGFloat  offsetX = self.collectionView.bounds.size.width * index;
    [self.collectionView setContentOffset:CGPointMake(offsetX, 0)];
}

@end
