//
//  VideoView.m
//  MyVideoPlayer
//
//  Created by duxiaoqiang on 2017/7/20.
//  Copyright © 2017年 professional. All rights reserved.
//

#import "VideoView.h"
#import "DQVideoRemotePlayer.h"
@interface VideoView()
@property (weak, nonatomic) IBOutlet UILabel *showTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *sliderView;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *pauseBtn;
@property (weak, nonatomic) IBOutlet UIButton *screenBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UISlider *slider;

@property (nonatomic,strong)  DQVideoRemotePlayer * player;
@property (nonatomic,assign) BOOL isPause ;
@property (nonatomic,strong) NSTimer *timer;
@end
@implementation VideoView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.slider setThumbImage:[UIImage imageNamed:@"btn_player_selected"] forState:UIControlStateNormal];
    [self.slider addTarget:self action:@selector(dragSlider) forControlEvents:UIControlEventTouchUpInside];
}

- (instancetype)initVideView
{
    if (self = [super init]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"VideoView" owner:nil options:nil] firstObject];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickVideo)]];
    }
    return self;
}


#pragma mark - 拖动滑竿
- (void)dragSlider
{
    [self.player seekWithProgress:self.slider.value];
}

- (void)setPlayLayerFrame:(CGRect)frame
{
    if (self.player) {
        self.player.playerLayer.frame = frame;
    }
}
#pragma mark - 播放暂停系列操作
- (void)startPlay:(NSURL *)addressURL
{
    DQVideoRemotePlayer * player = [DQVideoRemotePlayer shareInstance];
    [player playWithURL:addressURL frame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self.layer insertSublayer:player.playerLayer atIndex:0];
    self.bottomView.hidden = YES;
    self.player = player;
    self.isPause = NO;
    [self startTimer];
}

- (void)startTimer
{
     self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(upDateLabel) userInfo:nil repeats:YES];
}

- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}
- (void)upDateLabel
{
    self.showTimeLabel.text = self.player.currentTimeFormat;
    [self.slider setValue:self.player.progress];
    if(self.player.totalTime > 0)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            self.totalTimeLabel.text = self.player.totalTimeFormat;
        });
    }
}
- (void)stop
{
    if (self.player) {
        [self.player stop];
        [self.player removeObserver];
    }
}
#pragma mark -  暂停继续播放
- (IBAction)playStateClick:(id)sender {
    if (self.isPause) {
        [self startTimer];
        [self.player resume];
        [self.pauseBtn setImage:[UIImage imageNamed:@"btn_player_play"] forState:UIControlStateNormal];
        self.isPause = NO;
    }else
    {
        [self stopTimer];
        [self.player pause];
        [self.pauseBtn setImage:[UIImage imageNamed:@"btn_player_pause"] forState:UIControlStateNormal];
        self.isPause = YES;
    }
}
- (void)clickVideo
{
    self.bottomView.hidden = ! self.bottomView.isHidden;
}

// 全屏点击播放
- (IBAction)AllScreenClick:(id)sender {
    if (self.changeScreen) {
        self.changeScreen();
    }
}


@end
