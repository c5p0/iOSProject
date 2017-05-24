//
//  DQPublishTestViewController.m
//  DQCustom封装
//  测试发布VIew
//  Created by duxiaoqiang on 2017/5/24.
//  Copyright © 2017年 professional. All rights reserved.
//

#import "DQPublishTestViewController.h"
#import "DQPublishView.h"

@interface DQPublishTestViewController ()
<
UIActionSheetDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate
>
@property (nonatomic,strong) DQPublishView *publishView;
@property (nonatomic,strong) UIActionSheet *sheet;
@end

@implementation DQPublishTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.publishView];
    self.publishView.addPicClickBlock = ^{
         [self.sheet showInView:self.view];
    };
    self.publishView.incrementHBlock = ^(CGFloat inHeight) {
        CGRect oldFrame = self.publishView.frame;
        oldFrame.size.height += inHeight;
        self.publishView.frame = oldFrame;
    };
    self.view.backgroundColor = [UIColor lightGrayColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(DQPublishView* )publishView
{
    if(!_publishView)
    {
        _publishView = [[DQPublishView alloc] initWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, 250)];
    }
    return _publishView;
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    int sourceType = -1;
    if (buttonIndex == 0) {
        sourceType = UIImagePickerControllerSourceTypeCamera;
    }else if(buttonIndex == 1)
    {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }else{
        [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
    }
    if(sourceType != -1){
        //创建图片选择器
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        
        if (sourceType == UIImagePickerControllerSourceTypeCamera) {
            //指定源的类型
            BOOL isCamera = [UIImagePickerController
                             isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
            if(!isCamera) {
                NSLog(@"没有摄像头");
                return;
            }
        }
        imagePicker.sourceType = sourceType;
        
        //在选定图片之前，用户可以简单编辑要选的图片。包括上下移动改变图片的选取范围，用手捏合动作改变图片的大小等。
        imagePicker.allowsEditing = YES;
        
        //实现委托，委托必须实现UIImagePickerControllerDelegate协议，来对用户在图片选取器中的动作
        imagePicker.delegate = self;
        
        //设置完iamgePicker后，就可以启动了。用以下方法将图像选取器的视图“推”出来
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    self.publishView.selectImageArray = [NSMutableArray arrayWithObject:image];
//    _tImage = image;
//    [[SDImageCache sharedImageCache] storeImage:image forKey:self.nativeURL completion:nil];
//    __weak typeof(self) weakSelf = self;
//    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(UIActionSheet* )sheet
{
    if(!_sheet)
    {
        _sheet = [[UIActionSheet alloc] initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    }
    return _sheet;
}
@end
