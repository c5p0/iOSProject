//
//  XQCustomButton.m
//  MyTraning
//
//  Created by duxiaoqiang on 2017/7/26.
//  Copyright © 2017年 professional. All rights reserved.
//

#import "XQCustomButton.h"

@implementation XQCustomButton

-(void)layoutSubviews {
    [super layoutSubviews];
    CGFloat midX = self.frame.size.width / 2;
    CGFloat midY = self.frame.size.height/ 2 ;
    self.titleLabel.center = CGPointMake(midX, midY + 15);
    self.imageView.center = CGPointMake(midX, midY - 10);
}


@end
