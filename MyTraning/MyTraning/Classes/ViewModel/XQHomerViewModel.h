//
//  XQHomerViewModel.h
//  MyTraning
//
//  Created by duxiaoqiang on 2017/7/26.
//  Copyright © 2017年 professional. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XQHomerViewModel : NSObject
+ (void)featchBannerData:(void(^)(NSArray * result,NSError * error)) block;

+ (void)login:(NSString * )phoneNum password:(NSString *)password block:(void(^)(NSDictionary * result,NSError * error)) block;

+ (void)loginTest:(NSString * )phoneNum token:(NSString *)token block:(void(^)(NSDictionary * result,NSError * error)) block;
@end
