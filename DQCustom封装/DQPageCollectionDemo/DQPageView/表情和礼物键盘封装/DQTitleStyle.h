//
//  DQTitleStyle.h
//  DQCustom封装
//
//  Created by duxiaoqiang on 2017/4/26.
//  Copyright © 2017年 professional. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DQTitleStyle : NSObject
/// title是否可以滚动 默认true
@property (nonatomic,assign) BOOL isScrollEnable;
/// titleView的高度 默认值为44
@property (nonatomic,assign) CGFloat titleHeight ;
/// 标题普通Title颜色
@property (nonatomic,strong) UIColor *normalColor;
/// 标题选中Title颜色
@property (nonatomic,strong) UIColor *selectedColor;
/// 是否显示标题滚动线   默认显示
@property (nonatomic,assign) BOOL isShowLine;
/// title显示的字体大小 默认16
@property (nonatomic,strong) UIFont * titleFontSize ;
/// title 一行最多显示多少列 默认5列
@property (nonatomic,assign) NSInteger defaultCols ;
//  titleView 的背景颜色 默认为clear
@property (nonatomic,strong) UIColor * titleBgColor;
@end
