//
//  DQBannerView.h
//  test
//
//  Created by duxiaoqiang on 2017/4/24.
//  Copyright © 2017年 professional. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, DQBannerSourceType) {
    DQBannerSourceTypeFromLocal = 0,
    DQBannerSourceTypeFromURL
};
@class DQBannerView;
@protocol DQBannerViewDelegate <NSObject>
- (void)picSelectedIndex:(DQBannerView *)bannerView selectedIndex:(NSInteger )index;
@end
@interface DQBannerView : UIView
// 不传frame默认有值
+ (instancetype)bannerView;
// 由开发人员自己决定
+ (instancetype)bannerView:(CGRect)frame;
@property (nonatomic,weak) id<DQBannerViewDelegate> delegate;

// 图片地址URL 必须赋值
@property (nonatomic,strong) NSArray *imageUrlArray;
// 图片占位图片  可选赋值
@property (nonatomic,strong) UIImage *placeHolderImage;
// 图片标题集合  可选赋值
@property (nonatomic,strong) NSArray *titlesArray;
// 判断是来自于本地或者网络 必须赋值
@property (nonatomic,assign) DQBannerSourceType type;
// 是否需要显示PageConTrol 默认显示
@property (nonatomic,assign) BOOL showPageControl;

@end
