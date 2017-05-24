//
//  DQPublishView.m
//  DQCustom封装
//
//  Created by duxiaoqiang on 2017/5/24.
//  Copyright © 2017年 professional. All rights reserved.
//

#import "DQPublishView.h"
#import "DQPlaceholderTextView.h"
#import "DQPublishCell.h"
#define margin 10
@interface DQPublishView()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>
@property (nonatomic,strong) DQPlaceholderTextView *textView;
@property (nonatomic,strong) UICollectionView  *collectionView;
@property (nonatomic,strong) NSMutableArray *pickImageArray;
@property (nonatomic,assign) CGFloat itemWH ;
@property (nonatomic,assign) NSInteger lastCol ;
@end
@implementation DQPublishView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    self.textView = [[DQPlaceholderTextView alloc] init];
    self.textView.placeholder = @"请输入需要发布的内容";
    [self addSubview:self.textView];
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = margin;
    layout.minimumInteritemSpacing = margin;
    CGFloat itemWH = ([UIScreen mainScreen].bounds.size.width - 5*margin) * 0.25;
    self.itemWH = itemWH;
    layout.itemSize = CGSizeMake(itemWH, itemWH);
    layout.sectionInset = UIEdgeInsetsMake(0, margin, 0, margin);
    UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([DQPublishCell class]) bundle:nil] forCellWithReuseIdentifier:@"UICollectionViewCellID"];
    [self addSubview:collectionView];
    collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView = collectionView;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.pickImageArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DQPublishCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCellID" forIndexPath:indexPath];
    cell.showImageVIew.image = self.pickImageArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    if (indexPath.row + 1 == self.pickImageArray.count && self.addPicClickBlock) {
        self.addPicClickBlock();
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textView.frame = CGRectMake(0, 0, self.bounds.size.width, 150);
    self.collectionView.frame = CGRectMake(0, CGRectGetMaxY(self.textView.frame), self.bounds.size.width, self.bounds.size.height - 150);
}

- (void)setSelectImageArray:(NSMutableArray *)selectImageArray
{
    _selectImageArray = selectImageArray;
    if (selectImageArray.count == 9) {
        [self.pickImageArray removeAllObjects];
        [self.pickImageArray addObjectsFromArray:selectImageArray];
    }else{
        [selectImageArray addObjectsFromArray:self.pickImageArray];
        [self.pickImageArray removeAllObjects];
        [self.pickImageArray addObjectsFromArray:selectImageArray];
    }
    // 增加几行
    NSInteger col = 0;
    if (self.pickImageArray.count > 4 && self.pickImageArray.count < 9) {
        col = 1;
    }else if(self.pickImageArray.count >= 9)
    {
        col = 2;
    }
    
    if(self.lastCol != col)
    {
        self.lastCol = col;
        CGFloat height = margin + _itemWH;
        if (height > 0 && self.incrementHBlock) {
            self.incrementHBlock(height);
        }
    }
    
    [self.collectionView reloadData];
}

-(NSMutableArray* )pickImageArray
{
    if(!_pickImageArray)
    {
        _pickImageArray = [NSMutableArray array];
        [_pickImageArray addObject:[UIImage imageNamed:@"GGGrowth_addpicture"]];
    }
    return _pickImageArray;
}
@end
