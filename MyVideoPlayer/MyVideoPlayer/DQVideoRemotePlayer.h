//
//  DQVideoRemotePlayer.h
//  MyVideoPlayer
//
//  Created by duxiaoqiang on 2017/7/19.
//  Copyright © 2017年 professional. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
/**
 * 播放器的状态
 * 因为UI界面需要加载状态显示, 所以需要提供加载状态
 - DQRemotePlayerStateUnknown: 未知(比如都没有开始播放音乐)
 - DQRemotePlayerStateLoading: 正在加载()
 - DQRemotePlayerStatePlaying: 正在播放
 - DQRemotePlayerStateStopped: 停止
 - DQRemotePlayerStatePause:   暂停
 - DQRemotePlayerStateFailed:  失败(比如没有网络缓存失败, 地址找不到)
 */
typedef NS_ENUM(NSInteger, DQRemotePlayerState) {
    DQRemotePlayerStateUnknown = 0,
    DQRemotePlayerStateLoading   = 1,
    DQRemotePlayerStatePlaying   = 2,
    DQRemotePlayerStateStopped   = 3,
    DQRemotePlayerStatePause     = 4,
    DQRemotePlayerStateFailed    = 5
};
@interface DQVideoRemotePlayer : NSObject
@property (nonatomic,strong) AVPlayerLayer *playerLayer;
- (void)playWithURL:(NSURL *)url frame:(CGRect) frame;
/** 单例对象 */
+ (instancetype)shareInstance;

- (void)resume;

- (void)pause;

- (void)stop;

/** 是否静音, 可以反向设置数据 */
@property (nonatomic, assign) BOOL muted;
/** 音量大小 */
@property (nonatomic, assign) float volume;
/** 当前播放速率 */
@property (nonatomic, assign) float rate;

/**
 播放指定的进度
 
 @param progress 进度信息
 */
- (void)seekWithProgress:(float)progress;
- (void)removeObserver;

/**
 指定时间播放

 */
- (void)seekWithTimeDiffer:(NSTimeInterval)timeDiffer;

/** 播放状态 */
@property (nonatomic, assign) DQRemotePlayerState state;
/** 总时长 */
@property (nonatomic, assign, readonly) NSTimeInterval totalTime;
/** 总时长(格式化后的) */
@property (nonatomic, copy, readonly) NSString *totalTimeFormat;
/** 已经播放时长 */
@property (nonatomic, assign, readonly) NSTimeInterval currentTime;
/** 已经播放时长(格式化后的) */
@property (nonatomic, copy, readonly) NSString *currentTimeFormat;
/** 加载进度 */
@property (nonatomic, assign, readonly) float loadDataProgress;
/** 播放进度 */
@property (nonatomic, assign, readonly) float progress;
@end
