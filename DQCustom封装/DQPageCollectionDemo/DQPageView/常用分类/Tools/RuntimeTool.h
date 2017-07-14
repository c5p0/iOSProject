//
//  RuntimeTool.h
//  DQCustom封装
//
//  Created by duxiaoqiang on 2017/7/14.
//  Copyright © 2017年 professional. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RuntimeTool : NSObject

/**
 利用runtime获取一个类所有属性

 @param aClass 类
 @return 所有属性的数组集合
 */
- (NSArray *)allPropertyNames:(Class)aClass;
@end
