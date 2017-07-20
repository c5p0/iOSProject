//
//  PlayVideoViewController.m
//  MyVideoPlayer
//
//  Created by duxiaoqiang on 2017/7/19.
//  Copyright © 2017年 professional. All rights reserved.
//

#import "PlayVideoViewController.h"
#import "DQVideoRemotePlayer.h"
#import "VideoView.h"

@interface PlayVideoViewController ()
@property (weak, nonatomic) IBOutlet UIView *playerView;
@property (nonatomic,assign) BOOL isALLScreen ;
@property (nonatomic,strong) VideoView *videoView;
@end

@implementation PlayVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    DQVideoRemotePlayer * palyer = [DQVideoRemotePlayer shareInstance];
    NSURL * videoURl = [NSURL URLWithString:@"http://192.168.33.64:8080/test.mp4"];
//    CGRect videoFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 220);
//    [palyer playWithURL:videoURl isCache:NO frame:videoFrame];
//    [self.playerView.layer addSublayer:palyer.playerLayer];
    //[palyer  play];
     self.videoView = [[VideoView alloc] initVideView];
    self.videoView.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 220);
    [self.view addSubview:self.videoView];
    [self.videoView startPlay:videoURl];
    __weak typeof(self) wakeSelf = self;
    self.videoView.changeScreen = ^{
        wakeSelf.isALLScreen = !wakeSelf.isALLScreen;
        if (wakeSelf.isALLScreen) {
            [[UIDevice currentDevice]setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait]  forKey:@"orientation"];//这句话是防止手动先把设备置为横屏,导致下面的语句失效.
            
            [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
            
            [UIView animateWithDuration:0.5 animations:^{
                
                wakeSelf.videoView.frame= wakeSelf.view.bounds;
                [wakeSelf.videoView setPlayLayerFrame:wakeSelf.videoView.frame];
            } completion:^(BOOL finished) {
                
            }];
        }else {
        
            [[UIDevice currentDevice]setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft]  forKey:@"orientation"];//这句话是防止手动先把设备置为横屏,导致下面的语句失效.
            
            [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
            
            [UIView animateWithDuration:0.5 animations:^{
                
                wakeSelf.videoView.frame= CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 220);
                [wakeSelf.videoView setPlayLayerFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 220)];
                
            } completion:^(BOOL finished) {
                
            }];
        }
    };
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)shouldAutorotate
{
    return YES;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    if (self.isALLScreen) { //如果是iPhone,且为竖屏的时候, 只支持竖屏
        return UIInterfaceOrientationMaskLandscape; //否者只支持横屏
    }else{
        
        return UIInterfaceOrientationMaskPortrait;
    }
    
}
- (void)dealloc
{
    NSLog(@"我销毁了 ");
    if (self.videoView) {
        [self.videoView stop];
    }
}

@end
