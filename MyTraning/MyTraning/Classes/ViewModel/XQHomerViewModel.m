//
//  XQHomerViewModel.m
//  MyTraning
//
//  Created by duxiaoqiang on 2017/7/26.
//  Copyright © 2017年 professional. All rights reserved.
//

#import "XQHomerViewModel.h"
#import "XQSessionManager.h"
#import <MJExtension/MJExtension.h>
#import "XQBannerModel.h"
@implementation XQHomerViewModel

+ (void)featchBannerData:(void (^)(NSArray * ,NSError *))block
{
    [[XQSessionManager shareInstance] request:RequestTypePost urlStr:@"home/getBanner" parameter:nil resultBlock:^(id responseObject, NSError *error) {
        if (responseObject) {
            // 字典转模型
            NSArray * contextArray = [responseObject objectForKey:@"context"];
            NSArray * bannerArray = [XQBannerModel mj_objectArrayWithKeyValuesArray:contextArray];
            block(bannerArray,error);
        }else{
            block(nil,error);
        }
    }];
}
+ (void)login:(NSString *)phoneNum password:(NSString *)password block:(void (^)(NSDictionary *, NSError *))block
{
    NSDictionary * param = @{
                             @"phoneNum":phoneNum,
                             @"password":password
                             };
    [[XQSessionManager shareInstance] requestWithActivity:RequestTypePost urlStr:@"home/login" parameter:param resultBlock:^(id responseObject, NSError *error) {
        if (responseObject) {
            // 字典转模型
            NSDictionary * dict = [responseObject objectForKey:@"context"];
        
            block(dict,error);
        }else{
            block(nil,error);
        }
    }];
}

+ (void)loginTest:(NSString *)phoneNum token:(NSString *)token block:(void (^)(NSDictionary *, NSError *))block
{
    NSDictionary * param = @{
                             @"phoneNum":phoneNum,
                             @"token":token
                             };
    [[XQSessionManager shareInstance] request:RequestTypePost urlStr:@"home/testToken" parameter:param resultBlock:^(id responseObject, NSError *error) {
        if (responseObject) {
            // 字典转模型
            NSDictionary * dict = [responseObject objectForKey:@"context"];
            
            block(dict,error);
        }else{
            block(nil,error);
        }
    }];

}
@end
