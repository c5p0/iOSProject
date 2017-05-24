//
//  DQPublishView.h
//  DQCustom封装
//
//  Created by duxiaoqiang on 2017/5/24.
//  Copyright © 2017年 professional. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DQPublishView : UIView
@property (nonatomic,strong) void(^addPicClickBlock)();
@property (nonatomic,strong) NSMutableArray *selectImageArray;
@property (nonatomic,strong) void(^incrementHBlock)(CGFloat inHeight);
@end
