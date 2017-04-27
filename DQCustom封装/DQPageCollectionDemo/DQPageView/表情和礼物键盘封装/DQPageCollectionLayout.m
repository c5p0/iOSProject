//
//  DQPageCollectionLayout.m
//  DQCustom封装
//
//  Created by duxiaoqiang on 2017/4/27.
//  Copyright © 2017年 professional. All rights reserved.
//

#import "DQPageCollectionLayout.h"
@interface DQPageCollectionLayout()
@property (nonatomic,strong) NSMutableArray * attrsArray;
@property (nonatomic,assign) CGFloat maxW ;
@end
@implementation DQPageCollectionLayout
-(NSMutableArray* )attrsArray
{
    if(!_attrsArray)
    {
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.rows = 2;
        self.cols = 4;
    }
    return self;
}
- (void)prepareLayout
{
    [super prepareLayout];
    // 计算itemW
    CGFloat itemW = (self.collectionView.bounds.size.width - self.sectionInset.left - self.sectionInset.right - (self.cols - 1)* self.minimumInteritemSpacing) / self.cols;
    CGFloat itemH = (self.collectionView.bounds.size.height - self.sectionInset.top - self.sectionInset.bottom - (self.rows - 1)*self.minimumLineSpacing) / self.rows;
    // 获取所有组
    // 总页数
    NSInteger pageNum = 0;
    NSInteger sectionCount = self.collectionView.numberOfSections;
    for (NSInteger section = 0; section < sectionCount; section++) {
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        for (NSInteger item = 0; item< itemCount; item++) {
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:item inSection:section];
            UICollectionViewLayoutAttributes * attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            NSInteger page = item / (self.cols * self.rows);
            NSInteger index = item % (self.cols * self.rows);
            CGFloat x = (self.sectionInset.left + (index % self.cols) * (itemW + self.minimumInteritemSpacing)) + self.collectionView.bounds.size.width * (page + pageNum);
            CGFloat y = self.sectionInset.top + (index / self.cols) * (itemH + self.minimumLineSpacing);
            
            attrs.frame = CGRectMake(x, y, itemW, itemH);
            [self.attrsArray addObject:attrs];
        }
        NSInteger sectionNum = (itemCount - 1) / (self.cols* self.rows) + 1;
        pageNum += sectionNum;
    }
    self.maxW  = pageNum * self.collectionView.bounds.size.width;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attrsArray;
}
- (CGSize)collectionViewContentSize
{
    return CGSizeMake(self.maxW, 0);
}
@end
