//
//  DQPageCollectionLayout.h
//  DQCustom封装
//
//  Created by duxiaoqiang on 2017/4/27.
//  Copyright © 2017年 professional. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DQPageCollectionLayout : UICollectionViewFlowLayout
// 列数默认4列
@property (nonatomic,assign) NSInteger cols ;
// 行数默认2行
@property (nonatomic,assign) NSInteger rows ;
@end
