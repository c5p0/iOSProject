//
//  XQSessionManager.h
//  喜马拉雅FM
//
//  Created by 王顺子 on 16/8/2.
//  Copyright © 2016年 小码哥. All rights reserved.
//


typedef enum{
    RequestTypeGet,
    RequestTypePost

}RequestType;

#import <UIKit/UIKit.h>
#import <AFNetworking.h>
@interface XQSessionManager : AFHTTPSessionManager
+ (instancetype)shareInstance;
- (void)request:(RequestType)requestType urlStr: (NSString *)urlStr parameter: (NSDictionary *)param resultBlock: (void(^)(id responseObject, NSError *error))resultBlock;
- (void)requestWithActivity:(RequestType)requestType urlStr: (NSString *)urlStr parameter: (NSDictionary *)param resultBlock: (void(^)(id responseObject, NSError *error))resultBlock;
// 是否有网络
- (BOOL)isReachable;
// 开启网络监测
- (void)startReachability;
@end
