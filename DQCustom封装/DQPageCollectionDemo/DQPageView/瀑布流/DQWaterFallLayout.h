//
//  DQWaterFallLayout.h
//  DQPageCollectionDemo
//  自定义瀑布流水布局
//  Created by duxiaoqiang on 2017/4/26.
//  Copyright © 2017年 professional. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DQWaterFallLayout;
@protocol DQWaterFallLayoutDataSource <NSObject>

@required
// 设置每个item 的高度
- (CGFloat)heightOfDQWaterFallLayout:(DQWaterFallLayout *)layout indexPath:(NSIndexPath *)indexPath;
@optional
// 设置流水布局显示多少列
- (NSInteger)numberOfColsDQWaterFallLayout:(DQWaterFallLayout *)layout;

@end

@interface DQWaterFallLayout : UICollectionViewFlowLayout
@property (nonatomic,weak) id<DQWaterFallLayoutDataSource> dataSource;
@end
