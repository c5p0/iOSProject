//
//  XQProfileViewController.m
//  MyTraning
//
//  Created by duxiaoqiang on 2017/7/27.
//  Copyright © 2017年 professional. All rights reserved.
//

#import "XQProfileViewController.h"
#import "XQCustomDefine.h"
#import "UIView+Extension.h"
#import "XQProfileModuleCell.h"
@interface XQProfileViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *loginBtn; // 点击登陆
@property (weak, nonatomic) IBOutlet UIImageView *loginDesLabel; // 尚未登录内容描述
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) NSArray *moduleArray;  // 模块Button数组
@property (nonatomic,strong) NSArray *moduleHighLightArray; // 模块Button高亮状态
@property (nonatomic,assign) CGSize itemSize; ;
@end

@implementation XQProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupLayout];
}

// 初始化Collection布局
- (void)setupLayout
{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat itemWH = kScrrenW / 3;
    self.itemSize = CGSizeMake(itemWH, itemWH);
    layout.itemSize = self.itemSize;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.collectionView setCollectionViewLayout:layout];
    self.collectionView.showsVerticalScrollIndicator = NO;
}

#pragma mark - ColldectionView 的代理和数据源
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.moduleArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XQProfileModuleCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XQProfileModuleCellID" forIndexPath:indexPath];
    [cell.moduleButton setImage:[UIImage imageNamed:self.moduleArray[indexPath.row]] forState:UIControlStateNormal];
    [cell.moduleButton setImage:[UIImage imageNamed:self.moduleHighLightArray[indexPath.row]] forState:UIControlStateHighlighted];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    NSLog(@"----");
}



#pragma mark - 点击事件

// 跳转登陆页面
- (IBAction)gotoLogin:(id)sender {
}
// 消息点击
- (IBAction)msgClick:(id)sender {
}
// 签约记录
- (IBAction)signClick:(id)sender {
}
// 月嫂私单
- (IBAction)privateOrderClick:(id)sender {
}

#pragma mark - 懒加载
-(NSArray* )moduleArray
{
    if(!_moduleArray)
    {
        _moduleArray = @[@"wode",@"youhui",@"saoyisao",@"zixun",@"fenxiang",@"fankui",@"gengxin",@"wenti"];
    }
    return _moduleArray;
}
-(NSArray* )moduleHighLightArray
{
    if(!_moduleHighLightArray)
    {
        _moduleHighLightArray = @[@"wodedianji",@"youhuidianji",@"saoyisaodianji",@"zixundianji",@"fenxiangdianji",@"fankuidianji",@"gengxindianji",@"wentidianji"];
    }
    return _moduleHighLightArray;
}
@end
