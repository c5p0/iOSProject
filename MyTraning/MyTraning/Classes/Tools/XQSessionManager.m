//
//  XQCustomDefine.h
//  MyTraning
//
//  Created by duxiaoqiang on 2017/7/25.
//  Copyright © 2017年 professional. All rights reserved.
//

#import "XQSessionManager.h"
#import <Toast/UIView+Toast.h>
#import "XQCustomDefine.h"
@interface XQSessionManager()
@end

@implementation XQSessionManager
+ (instancetype)shareInstance
{
    static XQSessionManager *instence;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,
                  ^{
                      //instence = [[self alloc]init];
                      NSURL *baseUrl = [NSURL URLWithString:BaseURL];
                      instence = [[XQSessionManager alloc] initWithBaseURL:baseUrl sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
                      NSSet * set = [[NSSet alloc] initWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/plain",@"text/html",nil];
                      instence.responseSerializer.acceptableContentTypes = set;
                  });
    
    return instence;
}


- (void)request:(RequestType)requestType urlStr: (NSString *)urlStr parameter: (NSDictionary *)param resultBlock: (void(^)(id responseObject, NSError *error))resultBlock {
    [self requestNet:requestType isShowActivity:NO urlStr:urlStr parameter:param resultBlock:resultBlock];
}

- (void)requestWithActivity:(RequestType)requestType urlStr:(NSString *)urlStr parameter:(NSDictionary *)param resultBlock:(void (^)(id, NSError *))resultBlock
{
     [self requestNet:requestType isShowActivity:YES urlStr:urlStr parameter:param resultBlock:resultBlock];
}

- (void)requestNet:(RequestType)requestType isShowActivity:(BOOL) showActivity urlStr:(NSString *)urlStr parameter:(NSDictionary *)param resultBlock:(void (^)(id, NSError *))resultBlock
{
    // 如果没有网络
    if (![self isReachable]) {
        return ;
    }
    if (showActivity) {
        [self showActivity];
    }
    
    if (requestType == RequestTypeGet) {
        [self GET:urlStr parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self hideActivity:showActivity];
            resultBlock(responseObject, nil);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self hideActivity:showActivity];
            resultBlock(nil, error);
        }];
    }else {
        [self POST:urlStr parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self hideActivity:showActivity];
            resultBlock(responseObject, nil);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self hideActivity:showActivity];
            resultBlock(nil, error);
        }];
    }
}

- (void)showActivity
{
     [[UIApplication sharedApplication].delegate.window makeToastActivity:CSToastPositionCenter];
}

- (void)hideActivity:(BOOL) showActivity
{
    if(showActivity)
    {
        [[UIApplication sharedApplication].delegate.window hideToastActivity];
    }
}
- (BOOL)isReachable
{
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusUnknown)
    {
        return YES;
    }
    return [AFNetworkReachabilityManager sharedManager].isReachable;
}

- (void)startReachability
{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable || status == AFNetworkReachabilityStatusUnknown) {
            [[UIApplication sharedApplication].delegate.window makeToast:@"当前网络不稳定,请检查网络再试!"];
        }
    }];
    // 开启检查
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}



@end
