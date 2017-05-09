//
//  GlassViewController.m
//  使用GPU实现毛玻璃效果
//
//  Created by duxiaoqiang on 2017/5/3.
//  Copyright © 2017年 professional. All rights reserved.
//

#import "GlassViewController.h"
#import <GPUImage/GPUImage.h>
#import <IHKeyboardAvoiding/IHKeyboardAvoiding.h>
@interface GlassViewController ()
@property (weak, nonatomic) IBOutlet UITextField *testFiled;

@end

@implementation GlassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [IHKeyboardAvoiding setAvoidingView:self.testFiled];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UIImage * source  = [UIImage imageNamed:@"test"];
    // 创建用于处理单张图片
    GPUImagePicture * processView = [[GPUImagePicture alloc] initWithImage:source];
    
    // 创建滤镜
    GPUImageGaussianBlurFilter * blurFilter = [[GPUImageGaussianBlurFilter alloc] init];
    
    // 纹理处理
    blurFilter.texelSpacingMultiplier = 2.0;
    blurFilter.blurRadiusInPixels = 5.0;
    [processView addTarget:blurFilter];
    
    // 处理图像
    [blurFilter useNextFrameForImageCapture];
    [processView processImage];
    
    // 获取最新的图像
    UIImage  *newImage = [blurFilter imageFromCurrentFramebuffer];
    
    UIImageView * tempImageView = [[UIImageView alloc] initWithImage:newImage];
    tempImageView.frame = self.view.bounds;
    [self.view addSubview:tempImageView];
    
}

@end
