//
//  ImageCache.m
//  CenturyGuard
//
//  Created by 夏州 on 15-5-7.
//  Copyright (c) 2015年 sjyt. All rights reserved.
//

#import "ImageCache.h"

UIKIT_STATIC_INLINE NSString *ImageCacheKeyFromURLRequest(NSURLRequest *theRequest)
{
    return [[theRequest URL] absoluteString];
}

@implementation ImageCache

- (UIImage *)cachedImageForRequest:(NSURLRequest *)theRequest
{
    if (theRequest.cachePolicy == NSURLRequestReloadIgnoringCacheData ||
        theRequest.cachePolicy == NSURLRequestReloadIgnoringLocalAndRemoteCacheData ||
        theRequest.cachePolicy == NSURLRequestReloadIgnoringLocalCacheData)
    {
        return nil;
    }
    
    return [self objectForKey:ImageCacheKeyFromURLRequest(theRequest)];
}

- (void)cacheImage:(UIImage *)theImage forRequest:(NSURLRequest *)theRequest
{
    [self setObject:theImage forKey:ImageCacheKeyFromURLRequest(theRequest)];
}

- (void)removeCacheWithRequest:(NSURLRequest *)theRequest
{
    [self removeObjectForKey:ImageCacheKeyFromURLRequest(theRequest)];
}

- (void)removeAllCache
{
    [self removeAllObjects];
}

+ (ImageCache *)shareInstance
{
    static dispatch_once_t onceToken;
    static ImageCache *instance = nil;
    
    dispatch_once(&onceToken, ^{
        
        instance = [[ImageCache alloc]init];
        
        [[NSNotificationCenter defaultCenter]addObserverForName:UIApplicationDidReceiveMemoryWarningNotification
                                                         object:nil
                                                          queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
                                                              
                                                              [instance removeAllObjects];
                                                              
                                                          }];
    });
    
    return instance;
}

@end
