//
//  RuntimeTool.m
//  DQCustom封装
//
//  Created by duxiaoqiang on 2017/7/14.
//  Copyright © 2017年 professional. All rights reserved.
//

#import "RuntimeTool.h"
#import <objc/objc-runtime.h>
@implementation RuntimeTool

- (NSArray *)allPropertyNames:(Class)aClass
{
    unsigned count;
    objc_property_t *properties = class_copyPropertyList(aClass, &count);
    
    NSMutableArray *rv = [NSMutableArray array];
    
    unsigned i;
    for (i = 0; i < count; i++)
    {
        objc_property_t property = properties[i];
        NSString *name = [NSString stringWithUTF8String:property_getName(property)];
        [rv addObject:name];
    }
    
    free(properties);
    
    return rv;
}
@end
