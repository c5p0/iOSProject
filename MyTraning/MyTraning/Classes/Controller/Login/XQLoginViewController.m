//
//  XQLoginViewController.m
//  MyTraning
//
//  Created by duxiaoqiang on 2017/7/27.
//  Copyright © 2017年 professional. All rights reserved.
//

#import "XQLoginViewController.h"
#import "CGLimitedTextField.h"
#import "XQCustomDefine.h"
#import "XQHomerViewModel.h"
#define  MaxPhoneNum  11
#define  MaxCheckCode  6
@interface XQLoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet CGLimitedTextField *phoneNumLable;
@property (weak, nonatomic) IBOutlet CGLimitedTextField *checkCodeLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (nonatomic,strong) UIImageView *rightImageView;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) NSInteger countTime ;

@end

@implementation XQLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"手机验证";
    [self setupUI];
    // 60秒
    self.countTime = 60;
}

- (void)setupUI
{
    self.phoneNumLable.limitedNumber = MaxPhoneNum;
    self.checkCodeLabel.limitedNumber = MaxCheckCode;
    self.phoneNumLable.delegate = self;
    self.rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Prompt_tubiao1"]];
    self.rightImageView.frame = CGRectMake(0, 2, 26, 26);
    self.phoneNumLable.rightView = self.rightImageView;
    self.phoneNumLable.rightViewMode = UITextFieldViewModeNever;
    __weak typeof(self) wakeSelf = self;
    self.phoneNumLable.TextFieldNotifiChange = ^(NSString *content) {
        [wakeSelf changeTextField:content];
    };
    
}
- (void)changeTextField:(NSString *)content
{
    NSInteger len = content.length ;
    [self setDisableButton];
    if(len == 0){
        self.phoneNumLable.rightViewMode = UITextFieldViewModeNever;
    }else if (len > 0 && len < 11) {
        self.phoneNumLable.rightViewMode = UITextFieldViewModeAlways;
        self.rightImageView.image = [UIImage imageNamed:@"Prompt_tubiao1"];
    }else if(len >= MaxPhoneNum)
    {
        [self setEnableButton];
        
    }
    
}

// 设置不可用的Button
- (void) setDisableButton
{
    [self.checkButton setBackgroundImage:[UIImage imageNamed:@"disableBtn"] forState:UIControlStateNormal];
    self.checkButton.titleLabel.textColor = GrayFontColor;
    self.checkButton.userInteractionEnabled = NO;
}

// 设置可以Button 样式
- (void)setEnableButton
{
    self.rightImageView.image = [UIImage imageNamed:@"chenggongtishi"];
    [self.checkButton setBackgroundImage:[UIImage imageNamed:@"enableBtn"] forState:UIControlStateNormal];
    [self.checkButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.checkButton.userInteractionEnabled = YES;
}

- (void)startTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFire) userInfo:nil repeats:YES];
}

- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)timeFire
{
    if (self.countTime == 0) {
        [self stopTimer];
        [self setEnableButton];
        [self.checkButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        return;
    }
    // 更改UIButton上面的文字
    NSString * showText = [NSString stringWithFormat:@"%zd秒",self.countTime];
    self.countTime --;
    [self.checkButton setTitle:showText forState:UIControlStateNormal];
    
}

// 验证码
- (IBAction)checkCodeClick:(id)sender {
    self.countTime = 60;
    [self startTimer];
    [self setDisableButton];
}
// 登录按钮
- (IBAction)loginBtnClick:(id)sender {
    [XQHomerViewModel login:self.phoneNumLable.text password:self.checkCodeLabel.text block:^(NSDictionary *result, NSError *error) {
        NSString * status = [result objectForKey:@"status"];
        if ([status isEqualToString:@"success"]) {
            NSString * token = [result objectForKey:@"token"];
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:token forKey:@"token"];
            [defaults synchronize];
        }else{
            NSLog(@"登录失败 !!!");
        }
    }];
}

@end
