//
//  DQVideoRemotePlayer.m
//  MyVideoPlayer
//
//  Created by duxiaoqiang on 2017/7/19.
//  Copyright © 2017年 professional. All rights reserved.
//

#import "DQVideoRemotePlayer.h"

@interface DQVideoRemotePlayer()<NSCopying, NSMutableCopying>
{
    // 标识用户是否进行了手动暂停
    BOOL _isUserPause;
}
@property (nonatomic,strong) AVPlayer *player;
@property (nonatomic,strong) AVPlayerItem *item;
@end
@implementation DQVideoRemotePlayer
// 创建一个播放器对象
// 如果我们使用这样的方法, 去播放远程音频
// 这个方法, 已经帮我们封装了三个步骤
// 1. 资源的请求
// 2. 资源的组织
// 3. 给播放器, 资源的播放
// 如果资源加载比较慢, 有可能, 会造成调用了play方法, 但是当前并没有播放音频
- (void)playWithURL:(NSURL *)url frame:(CGRect)frame{
    NSURL *currentURL = [(AVURLAsset *)self.player.currentItem.asset URL];
    if (currentURL) {
        NSURLComponents *compents = [NSURLComponents componentsWithString:currentURL.absoluteString];
        compents.scheme = @"sreaming";
        if ([url isEqual:currentURL] || [compents.URL isEqual:currentURL]) {
            NSLog(@"当前播放任务已经存在");
            [self resume];
            return;
        }

    }
    if (self.player.currentItem) {
        [self removeObserver];
    }
    // 1. 资源的请求
    AVURLAsset *asset = [AVURLAsset assetWithURL:url];
    // 2. 资源的组织
    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset];
    [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [item addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
    [item addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
  
    // 播放结束通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    // 播放中断结束
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playInterupt) name:AVPlayerItemPlaybackStalledNotification object:nil];
    // 3. 资源的播放
    self.player = [AVPlayer playerWithPlayerItem:item];
    AVPlayerLayer * playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer = playerLayer;
    self.playerLayer.frame = frame;
    // AVLayerVideoGravityResizeAspect 按视频的原比例显示,是竖屏显示两边留黑
    // AVLayerVideoGravityResizeAspectFill是以原比例拉伸视频，直到两边屏幕都占满，但视频内容有部分就被切割了
    // AVLayerVideoGravityResize是拉伸视频内容达到边框占满，但不按原比例拉伸，这里明显可以看出宽度被拉伸了。
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
   
}
/**
 指定时间差播放
 
 @param timeDiffer 时间差
 */
- (void)seekWithTimeDiffer:(NSTimeInterval)timeDiffer {
    
    // 1. 当前音频资源的总时长
    NSTimeInterval totalTimeSec = [self totalTime];
    // 2. 当前音频, 已经播放的时长
    
    NSTimeInterval playTimeSec = [self currentTime];
    playTimeSec += timeDiffer;
    
    [self seekWithProgress:playTimeSec / totalTimeSec];
    
}

/**
 状态变更, 事件触发
 
 @param state 状态
 */
- (void)setState:(DQRemotePlayerState)state {
    _state = state;
    
    // 如果需要告知外界相关的事件
    // block
    // 代理
    // 发通知
    
}
#pragma mark - 播放结束
- (void)playEnd
{
    NSLog(@"播放完成");
    self.state = DQRemotePlayerStateStopped;
}
#pragma mark - 播放中断
- (void)playInterupt
{
    NSLog(@"播放被打断");
    self.state = DQRemotePlayerStatePause;
}
#pragma mark - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItemStatus status = [change[NSKeyValueChangeNewKey] integerValue];
        if (status == AVPlayerItemStatusReadyToPlay) {
            NSLog(@"资源准备好了, 这时候播放就没有问题");
            [self resume];
        }else {
            NSLog(@"状态未知");
            self.state = DQRemotePlayerStateFailed;
        }
    }else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
        BOOL ptk = [change[NSKeyValueChangeNewKey] boolValue];
        if (ptk) {
            NSLog(@"当前的资源, 准备的已经足够播放了");
            // 用户的手动暂停的优先级最高
            if (!_isUserPause) {
                [self resume];
            }else {
                
            }
            
        }else {
            NSLog(@"资源还不够, 正在加载过程当中");
            self.state = DQRemotePlayerStateLoading;
        }
    }else if([keyPath isEqualToString:@"loadedTimeRanges"])
    {
    }

}


/**
 继续播放
 */
- (void)resume {
    [self.player play];
    _isUserPause = NO;
    // 就是代表,当前播放器存在, 并且, 数据组织者里面的数据准备, 已经足够播放了
    if (self.player && self.player.currentItem.playbackLikelyToKeepUp) {
        self.state = DQRemotePlayerStatePlaying;
    }
}

/**
 播放速率
 
 @param rate 速率, 0.5 -- 2.0
 */
- (void)setRate:(float)rate {
    [self.player setRate:rate];
}

/**
 获取速率
 
 @return 速率
 */
- (float)rate {
    return self.player.rate;
}

/**
 设置静音
 
 @param muted 静音
 */
- (void)setMuted:(BOOL)muted {
    self.player.muted = muted;
}

/**
 是否静音
 
 @return 是否静音
 */
- (BOOL)muted {
    return self.player.muted;
}

/**
 声音大小
 
 @param volume 音量
 */
- (void)setVolume:(float)volume {
    
    if (volume < 0 || volume > 1) {
        return;
    }
    if (volume > 0) {
        [self setMuted:NO];
    }
    
    self.player.volume = volume;
}

/**
 声音大小
 
 @return 音量
 */
- (float)volume {
    return self.player.volume;
    
}


- (void)pause
{
    [self.player pause];
    _isUserPause = YES;
    if (self.player) {
        self.state = DQRemotePlayerStatePause;
    }
}

- (void)stop
{
    [self.player pause];
    self.player = nil;
    if (self.player) {
        self.state = DQRemotePlayerStateStopped;
    }

}
// 移除 监听通知
- (void)removeObserver {
    [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    [self.player.currentItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -  当前播放进度
- (float)progress {
    if (self.totalTime == 0) {
        return 0;
    }
    return self.currentTime / self.totalTime;
}

/**
 资源加载进度
 
 @return 加载进度
 */
- (float)loadDataProgress {
    
    if (self.totalTime == 0) {
        return 0;
    }
    
    CMTimeRange timeRange = [[self.player.currentItem loadedTimeRanges].lastObject CMTimeRangeValue];
    
    CMTime loadTime = CMTimeAdd(timeRange.start, timeRange.duration);
    NSTimeInterval loadTimeSec = CMTimeGetSeconds(loadTime);
    
    return loadTimeSec / self.totalTime;
    
}
#pragma mark - 指定进度播放
/**
 指定进度播放
 
 @param progress 进度
 */
- (void)seekWithProgress:(float)progress {
    
    if (progress < 0 || progress > 1) {
        return;
    }
    
    // 可以指定时间节点去播放
    // 时间: CMTime : 影片时间
    // 影片时间 -> 秒
    // 秒 -> 影片时间
    
    // 1. 当前音频资源的总时长
    CMTime totalTime = self.player.currentItem.duration;
    // 2. 当前音频, 已经播放的时长
    //    self.player.currentItem.currentTime
    
    NSTimeInterval totalSec = CMTimeGetSeconds(totalTime);
    NSTimeInterval playTimeSec = totalSec * progress;
    CMTime currentTime = CMTimeMake(playTimeSec, 1);
    
    [self.player seekToTime:currentTime completionHandler:^(BOOL finished) {
        if (finished) {
            NSLog(@"确定加载这个时间点的资源");
        }else {
            NSLog(@"取消加载这个时间点的资源");
        }
    }];
    
    
}


#pragma mark -  获取当前和总时长
// 总时长
- (NSString *)totalTimeFormat {
    return [NSString stringWithFormat:@"%02zd:%02zd", (int)self.totalTime / 60, (int)self.totalTime % 60];
}

/**
 当前资源总时长
 
 @return 总时长
 */
-(NSTimeInterval)totalTime {
    CMTime totalTime = self.player.currentItem.duration;
    NSTimeInterval totalTimeSec = CMTimeGetSeconds(totalTime);
    if (isnan(totalTimeSec)) {
        return 0;
    }
    return totalTimeSec;
}

/**
 当前资源播放时长
 
 @return 播放时长
 */
- (NSTimeInterval)currentTime {
    CMTime playTime = self.player.currentItem.currentTime;
    NSTimeInterval playTimeSec = CMTimeGetSeconds(playTime);
    if (isnan(playTimeSec)) {
        return 0;
    }
    return playTimeSec;
}
/**
 当前资源播放时长(格式化后)
 
 @return 播放时长
 */
- (NSString *)currentTimeFormat {
    return [NSString stringWithFormat:@"%02zd:%02zd", (int)self.currentTime / 60, (int)self.currentTime % 60];
}

#pragma mark - 单例方法
static DQVideoRemotePlayer *_shareInstance;
+ (instancetype)shareInstance {
    if (!_shareInstance) {
        _shareInstance = [[DQVideoRemotePlayer alloc] init];
    }
    return _shareInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    if (!_shareInstance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _shareInstance = [super allocWithZone:zone];
        });
    }
    return _shareInstance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _shareInstance;
}

-(id)mutableCopyWithZone:(NSZone *)zone {
    return _shareInstance;
}

@end
