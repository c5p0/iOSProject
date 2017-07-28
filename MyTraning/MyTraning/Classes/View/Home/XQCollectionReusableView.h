//
//  XQCollectionReusableView.h
//  MyTraning
//
//  Created by duxiaoqiang on 2017/7/26.
//  Copyright © 2017年 professional. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XQCollectionReusableView : UICollectionReusableView
@property (nonatomic,strong) NSMutableArray *picImageArray;

// 点击item
@property (nonatomic,strong) void(^ClickCategoryItemBlock)(NSInteger itemTag);

// 点击招聘简历
@property (nonatomic,strong) void(^RecruitClickBlock)();

// 在线签约
@property (nonatomic,strong) void(^SignClickBlock)();

// 薪资支付
@property (nonatomic,strong) void(^PayClickBlock)();
@end
