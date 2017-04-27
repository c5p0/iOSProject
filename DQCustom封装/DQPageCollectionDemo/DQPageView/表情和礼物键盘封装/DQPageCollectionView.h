//
//  DQPageCollectionView.h
//  DQCustom封装
//
//  Created by duxiaoqiang on 2017/4/27.
//  Copyright © 2017年 professional. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DQTitleStyle;
@class DQPageCollectionLayout;
@protocol DQPageCollectionViewDataSource <NSObject>
@required
- (NSInteger)numberofSections:(UICollectionView *)collectionView;
- (NSInteger)pageCollectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
- (UICollectionViewCell *)pageCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
@end

@protocol DQPageCollectionViewDelegate <NSObject>
- (void)pageCollectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
@end
@interface DQPageCollectionView : UIView

/**
 初始化实例

 @param frame 表情键盘的Frame
 @param titles 分类文字数组
 @param style  分类文字的样式
 @param isTitleInTop 是否显示在顶部
 @return 封装好的对象
 */
- (instancetype)initPageWithFrame:(CGRect )frame titles:(NSArray *)titles style:(DQTitleStyle *)style isTitleInTop:(BOOL)isTitleInTop layout:(DQPageCollectionLayout *)layout;

@property (nonatomic,weak) id<DQPageCollectionViewDataSource> dataSource;
@property (nonatomic,weak) id<DQPageCollectionViewDelegate> delegate;

- (void)registerClass:(Class )registerClass  forCellWithReuseIdentifier:(NSString *)identifier;
- (void)registerNib:(UINib * )nib  forCellWithReuseIdentifier:(NSString *)identifier;

// 设置PageControl的背景颜色和选中正常颜色
- (void)setPageControlColor:(UIColor *)bgColor selectedColor:(UIColor *)selectedColor normalColor:(UIColor *)normalColor;
// 设置内容背景颜色
- (void)setCollectionViewColor:(UIColor *)bgColor;
@end
