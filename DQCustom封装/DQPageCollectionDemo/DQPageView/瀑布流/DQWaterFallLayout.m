//
//  DQWaterFallLayout.m
//  DQPageCollectionDemo
//
//  Created by duxiaoqiang on 2017/4/26.
//  Copyright © 2017年 professional. All rights reserved.
//

#import "DQWaterFallLayout.h"
@interface DQWaterFallLayout()
@property (nonatomic,strong) NSMutableArray * attrsArray;
@property (nonatomic,strong) NSMutableArray * colHeights;
@property (nonatomic,assign) CGFloat maxH;
// 记录每次循环索引
@property (nonatomic,assign) NSInteger startIndex;
@end
@implementation DQWaterFallLayout


-(NSMutableArray* )attrsArray
{
    if(!_attrsArray)
    {
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}

-(NSMutableArray* )colHeights
{
    if(!_colHeights)
    {
        _colHeights = [NSMutableArray array];
        // 获取传入的列数把top内边距放入到数组中
        CGFloat cols = 2;
        if ([self.dataSource respondsToSelector:@selector(numberOfColsDQWaterFallLayout:)]) {
            cols = [self.dataSource numberOfColsDQWaterFallLayout:self];
        }
        for (NSInteger i= 0; i < cols ; i ++) {
            [_colHeights addObject:@(self.sectionInset.top)];
        }
    }
    return _colHeights;
}

// 具体实现items 的大小
- (void)prepareLayout
{
    [super prepareLayout];
    
    // 1: 获取所有的Item个数
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    
    // 获取列数
    NSInteger cols = 2;
    if ([self.dataSource respondsToSelector:@selector(numberOfColsDQWaterFallLayout:)]) {
        cols = [self.dataSource numberOfColsDQWaterFallLayout:self];
    }
    // 计算Item 的宽度
    CGFloat itemW = (self.collectionView.bounds.size.width - self.sectionInset.left - self.sectionInset.right - (cols - 1) * self.minimumInteritemSpacing) / cols;
    for (NSInteger i = _startIndex ;i<itemCount ; i++) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        CGFloat itemH = itemW;
        if ([self.dataSource respondsToSelector:@selector(heightOfDQWaterFallLayout:indexPath:)]) {
            itemH = [self.dataSource heightOfDQWaterFallLayout:self indexPath:indexPath];
        }
        // 计算列中最小的高度
        CGFloat minH = [self min];
        NSInteger index = [self.colHeights indexOfObject:@(minH)];
        minH = minH + itemH + self.minimumLineSpacing;
        self.colHeights[index] = @(minH);
        
        UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attrs.frame = CGRectMake(self.sectionInset.left + (self.minimumInteritemSpacing + itemW) * index, minH - itemH  - self.minimumLineSpacing, itemW, itemH);
        [self.attrsArray addObject:attrs];
    }
    self.maxH = [self max];
    self.startIndex = itemCount;
}

// 返回布局好的item frame数组集合
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attrsArray;
}
// 返回collection 滚动的最大Size
- (CGSize)collectionViewContentSize
{
    return  CGSizeMake(0, self.maxH + self.sectionInset.bottom - self.minimumLineSpacing);
}

- (CGFloat)max
{
    CGFloat maxH = [[self.colHeights firstObject] doubleValue];
    for (NSNumber * height in  self.colHeights)
    {
        if ([height floatValue] > maxH) {
            maxH = [height floatValue];
        }
    }
    return maxH;
}
- (CGFloat)min
{
    CGFloat minH = [[self.colHeights firstObject] doubleValue];
    for (NSNumber * height in  self.colHeights)
    {
        if ([height floatValue] < minH) {
            minH = [height floatValue];
        }
    }
    return minH;
}
@end
