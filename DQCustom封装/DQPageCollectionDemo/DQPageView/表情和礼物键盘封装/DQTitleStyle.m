//
//  DQTitleStyle.m
//  DQCustom封装
//
//  Created by duxiaoqiang on 2017/4/26.
//  Copyright © 2017年 professional. All rights reserved.
//

#import "DQTitleStyle.h"

@implementation DQTitleStyle

- (instancetype)init
{
    if (self = [super init]) {
        self.isScrollEnable = YES;
        self.titleHeight = 44;
        self.normalColor = [UIColor colorWithRed:0 / 255.0f green:0 / 255.0f blue:0/ 255.0f alpha:1.0f];
        self.selectedColor = [UIColor colorWithRed:255 / 255.0f green:127 / 255.0f blue:0/ 255.0f alpha:1.0f];
        self.isShowLine = YES;
        self.titleFontSize = [UIFont systemFontOfSize:16.0f];
        self.defaultCols = 5;
        self.titleBgColor = [UIColor clearColor];
    }
    return self;
}

@end
