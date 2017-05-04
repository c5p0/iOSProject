//
//  NSURL+SZ.h
//  播放器
//
//  Created by 小码哥 on 2017/1/14.
//  Copyright © 2017年 xmg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (SZ)


/**
 获取streaming协议的url地址
 */
- (NSURL *)streamingURL;


- (NSURL *)httpURL;

@end
