//
//  VideoView.h
//  MyVideoPlayer
//
//  Created by duxiaoqiang on 2017/7/20.
//  Copyright © 2017年 professional. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoView : UIView
- (instancetype)initVideView;

- (void)startPlay:(NSURL * )addressURL;
@property (nonatomic,strong) void(^changeScreen)();
// 全屏的时候
- (void)setPlayLayerFrame:(CGRect)frame;

- (void)stop;
@end
