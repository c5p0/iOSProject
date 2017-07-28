//
//  XQBannerModel.h
//  MyTraning
//
//  Created by duxiaoqiang on 2017/7/26.
//  Copyright © 2017年 professional. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XQBannerModel : NSObject
@property (nonatomic,assign) NSInteger bannerId ; // bannerid
@property (nonatomic,copy) NSString *picurl;      //图片地址
@property (nonatomic,copy) NSString *address;     // 加载地址
@end
