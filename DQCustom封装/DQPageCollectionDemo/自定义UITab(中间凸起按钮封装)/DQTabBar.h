//
//  DQTabBar.h
//  DQFM
//
//  Created by duxiaoqiang on 2017/4/24.
//  Copyright © 2017年 professional. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DQTabBar : UITabBar

/**
 点击中间按钮的执行代码块
 */
@property (nonatomic, copy) void(^middleClickBlock)(BOOL isPlaying);
@end
