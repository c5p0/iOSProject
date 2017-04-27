//
//  ImageCache.h
//  CenturyGuard
//
//  Created by 夏州 on 15-5-7.
//  Copyright (c) 2015年 sjyt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageCache : NSCache

+ (ImageCache *)shareInstance;

/**
 *  读缓存
 */
- (UIImage *)cachedImageForRequest:(NSURLRequest *)theRequest;

/**
 *  写缓存
 */
- (void)cacheImage:(UIImage *)theImage forRequest:(NSURLRequest *)theRequest;

/**
 *  清指定缓存
 */
- (void)removeCacheWithRequest:(NSURLRequest *)theRequest;

/**
 *  清所有缓存
 */
- (void)removeAllCache;

@end
