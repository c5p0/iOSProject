//
//  LiveViewController.m
//  DQCustom封装
//
//  Created by duxiaoqiang on 2017/5/2.
//  Copyright © 2017年 professional. All rights reserved.
//

#import "LiveViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface LiveViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate,AVCaptureFileOutputRecordingDelegate>
// 当前会话
@property (nonatomic,strong) AVCaptureSession *captureSession;
// 视频输入设备
@property (nonatomic,strong) AVCaptureDeviceInput *currentVideoDeviceInput;
// 视频输入输出连接
@property (nonatomic,strong) AVCaptureConnection *videoConnection;
// 视频预览图层
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *previedLayer;
// 视频文件写入
@property (nonatomic,strong) AVCaptureMovieFileOutput *fileOutPut;
@end

@implementation LiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 添加两个按钮 开始采集和停止采集

- (void)setupUI
{
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 40)];
    [btn1 setTitle:@"开始采集" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(startCapture) forControlEvents:UIControlEventTouchUpInside];
    btn1.backgroundColor = [UIColor blueColor];
      [self.view addSubview:btn1];
    
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 100, 40)];
    [btn2 setTitle:@"停止采集" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(stopCapture) forControlEvents:UIControlEventTouchUpInside];
    btn2.backgroundColor = [UIColor blueColor];
    [self.view addSubview:btn2];
    
    UIButton *btn3 = [[UIButton alloc] initWithFrame:CGRectMake(100, 260, 100, 40)];
    [btn3 setTitle:@"切换摄像头" forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(toggleCapture) forControlEvents:UIControlEventTouchUpInside];
    btn3.backgroundColor = [UIColor blueColor];
    [self.view addSubview:btn3];
}
- (void)startCapture{
    // 1: 创建捕捉会话
    AVCaptureSession * session = [[AVCaptureSession alloc] init];
    _captureSession = session;
    
    // 设置视频输入输出
    [self setupVideoSource];
    
    // 设置音频输入输出
    [self setupAudioSource];
    
    // 添加视频到预览图层
    [self setupPriview];
    // 开启会话
    [_captureSession startRunning];
    // 写入到文件
    [self setupMoveFile];
}
 
- (void)stopCapture{
    NSLog(@"停止采集");
    
    // 停止写入文件
    [self.fileOutPut stopRecording];
    [_previedLayer removeFromSuperlayer];
    [_captureSession stopRunning];
    _captureSession = nil;
}

    
- (void)setupVideoSource{
    // 如果有前置摄像头默认显示前置摄像头，否则显示后置摄像头
    AVCaptureDevice * videoCurrentDevice = [self getVideoDevice:AVCaptureDevicePositionFront];
    // 视频输入设备
    AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoCurrentDevice error:nil];
    _currentVideoDeviceInput = videoDeviceInput;
    if ([_captureSession canAddInput:videoDeviceInput]) {
        [_captureSession addInput:videoDeviceInput];
    }
    // 视频输出设备
    AVCaptureVideoDataOutput *videoOutput = [[AVCaptureVideoDataOutput alloc] init];

    
    // 7.1 设置代理，捕获视频样品数据
    // 注意：队列必须是串行队列，才能获取到数据，而且不能为空
    dispatch_queue_t videoQueue = dispatch_queue_create("Video Capture Queue", DISPATCH_QUEUE_SERIAL);
    [videoOutput setSampleBufferDelegate:self queue:videoQueue];
    if ([_captureSession canAddOutput:videoOutput]) {
        [_captureSession addOutput:videoOutput];
    }
    
    // 9.获取视频输入与输出连接，用于分辨音视频数据
    _videoConnection = [videoOutput connectionWithMediaType:AVMediaTypeVideo];
}

// 切换摄像头
- (void)toggleCapture
{
    // 获取当前设备方向
    AVCaptureDevicePosition curPosition = _currentVideoDeviceInput.device.position;
    
    // 获取需要改变的方向
    AVCaptureDevicePosition togglePosition = curPosition == AVCaptureDevicePositionFront?AVCaptureDevicePositionBack:AVCaptureDevicePositionFront;
    
    // 获取改变的摄像头设备
    AVCaptureDevice *toggleDevice = [self getVideoDevice:togglePosition];
    
    // 获取改变的摄像头输入设备
    AVCaptureDeviceInput *toggleDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:toggleDevice error:nil];
    
    // 移除之前摄像头输入设备
    [_captureSession removeInput:_currentVideoDeviceInput];
    
    // 添加新的摄像头输入设备
    [_captureSession addInput:toggleDeviceInput];
    
    // 记录当前摄像头输入设备
    _currentVideoDeviceInput = toggleDeviceInput;
}


- (AVCaptureDevice *)getVideoDevice:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if (device.position == position) {
            return device;
        }
    }
    return nil;
}

- (void)setupAudioSource
{
    // 1.获取声音设备
    AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    // 2.创建对应音频设备输入对象
    AVCaptureDeviceInput *audioDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:nil];
    
    // 3 添加音频
    if ([_captureSession canAddInput:audioDeviceInput]) {
        [_captureSession addInput:audioDeviceInput];
    }
    // 4.获取音频数据输出设备
    AVCaptureAudioDataOutput *audioOutput = [[AVCaptureAudioDataOutput alloc] init];
    // 5 设置代理，捕获视频样品数据
    // 注意：队列必须是串行队列，才能获取到数据，而且不能为空
    dispatch_queue_t audioQueue = dispatch_queue_create("Audio Capture Queue", DISPATCH_QUEUE_SERIAL);
    [audioOutput setSampleBufferDelegate:self queue:audioQueue];
    if ([_captureSession canAddOutput:audioOutput]) {
        [_captureSession addOutput:audioOutput];
    }
    
    
}
//把视频文件写到沙盒
- (void)setupMoveFile
{
    AVCaptureMovieFileOutput * fileOutput = [[AVCaptureMovieFileOutput alloc] init];
    _fileOutPut = fileOutput;
  
    // 获取视频的Connection
    AVCaptureConnection * connection = [fileOutput connectionWithMediaType:AVMediaTypeVideo];
    // 设置视频的稳定模式
    connection.preferredVideoStabilizationMode = YES;
    if ([_captureSession canAddOutput:fileOutput]) {
        [_captureSession addOutput:fileOutput];
    }
    NSString * pathUrl = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSURL * outputUrl = [NSURL fileURLWithPath:[pathUrl stringByAppendingPathComponent:@"aa.mp4"]];
    // 开始写入视频
    [fileOutput startRecordingToOutputFileURL:outputUrl recordingDelegate:self];
}

- (void)setupPriview
{
    // 10.添加视频预览图层
    AVCaptureVideoPreviewLayer *previedLayer = [AVCaptureVideoPreviewLayer layerWithSession:_captureSession];
    previedLayer.frame = [UIScreen mainScreen].bounds;
    [self.view.layer insertSublayer:previedLayer atIndex:0];
    _previedLayer = previedLayer;
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
// 获取输入设备数据，有可能是音频有可能是视频
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    if (_videoConnection == connection) {
        NSLog(@"采集到视频数据");
    } else {
        NSLog(@"采集到音频数据");
    }
}

#pragma mark - 视频写入监听开始和结束事件
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections
{
    NSLog(@"开始录制");
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    NSLog(@"停止录制");
}
@end
