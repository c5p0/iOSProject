//
//  lameTool.h
//  01- 录音
//
//  Created by duxiaoqiang on 2017/4/24.
//  Copyright © 2017年 professional. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LameTool : NSObject

+ (NSString *)audioToMP3: (NSString *)sourcePath isDeleteSourchFile: (BOOL)isDelete;

@end
