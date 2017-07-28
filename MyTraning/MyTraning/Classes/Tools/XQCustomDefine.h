//
//  XQCustomDefine.h
//  MyTraning
//
//  Created by duxiaoqiang on 2017/7/25.
//  Copyright © 2017年 professional. All rights reserved.
//

#ifndef XQCustomDefine_h
#define XQCustomDefine_h

// 定义一些常用的宏
#define RGB(r, g, b) [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:1.0f]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:a]
#define RandomColor()  [UIColor colorWithRed:arc4random_uniform(255)/255.0f green:arc4random_uniform(255)/255.0f blue:arc4random_uniform(255)/255.0f alpha:1.0]
#define UIStoryboardGetInstantiateViewController(StoryboardName, IdentifierOfViewController) [[UIStoryboard storyboardWithName:StoryboardName bundle:nil] instantiateViewControllerWithIdentifier:IdentifierOfViewController]
#define UIStoryboardGetInstantiateInitialController(StoryboardName) [[UIStoryboard storyboardWithName:StoryboardName bundle:nil] instantiateInitialViewController]
#define BaseURL @"http://192.168.33.64:8080/ito-web/"

#define DefaultFontColor [UIColor colorWithRed:56 / 255.0f green:56 / 255.0f blue:56 / 255.0f alpha:1.0f]
#define GreenFontColor [UIColor colorWithRed:92 / 255.0f green:184 / 255.0f blue:52 / 255.0f alpha:1.0f]
#define GrayFontColor [UIColor colorWithRed:133 / 255.0f green:133/ 255.0f blue:133/ 255.0f alpha:1.0f]
#define kScrrenW [UIScreen mainScreen].bounds.size.width
#define kScrrenH [UIScreen mainScreen].bounds.size.height
#endif /* XQCustomDefine_h */
typedef NS_ENUM(NSInteger,XQCategoryType) {
    XQCategoryTypeYueSao = 0, // 月嫂模块
    XQCategoryTypeYuEr = 1, // 育儿嫂模块
    XQCategoryTypeBuZhuJiaBaoMu = 2, //不住家保姆
    XQCategoryTypeZhuJiaBaoMu = 3, // 住家保姆
    XQCategoryTypePeiHuLaoRen = 4, // 老人陪护
    XQCategoryTypePeoHuBingRen = 5, // 病患陪护
    XQCategoryTypeLongXiaoShiGong = 6, // 长期小时工
    XQCategoryTypeXiaoShiGong = 7 // 小时工
};

typedef NS_ENUM(NSInteger,XQProfileModuleType) {
    XQProfileModuleTypeMe = 0, // 我的
    XQProfileModuleTypeCoupon = 1, // 优惠券模块
    XQProfileModuleTypeScan = 2, // 扫一扫
    XQProfileModuleTypeNews = 3, // 资讯
    XQProfileModuleTypeShare = 4, // 分享
    XQProfileModuleTypeSuggestion = 5, // 意见反馈
    XQProfileModuleTypeSystemUpdate = 6, // 系统更新
    XQProfileModuleTypeQuestion = 7 // 常见问题
};

