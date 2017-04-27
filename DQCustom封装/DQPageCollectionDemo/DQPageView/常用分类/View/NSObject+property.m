//
//  NSObject+property.m
//  runtime
//
//  Created by duxiaoqiang on 16/6/13.
//  Copyright © 2016年 professional. All rights reserved.
//

#import "NSObject+property.h"

@implementation NSObject (property)
+ (void)createProperty:(NSDictionary *)dict
{
    __block NSString * codeStr;
    [dict enumerateKeysAndObjectsUsingBlock:^(id  propertyName, id  _Nonnull value, BOOL * _Nonnull stop) {
        NSLog(@"%@,%@",propertyName,NSStringFromClass([value class]));
        
        NSString * code;
        if ([NSStringFromClass([value class]) isEqualToString:@"__NSCFConstantString"]) {  // 字符串
            //@property (nonatomic,strong) NSMutableArray *name;
            code = [NSString stringWithFormat:@"@property (nonatomic,copy) NSString *%@;",propertyName];
        }else if([NSStringFromClass([value class]) isEqualToString:@"__NSCFNumber"])  // 数值
        {
            code = [NSString stringWithFormat:@"@property (nonatomic,assign) NSInteger *%@;",propertyName];
        }else if([NSStringFromClass([value class]) isEqualToString:@"__NSCFBoolean"])  // boolean
        {
            code = [NSString stringWithFormat:@"@property (nonatomic,assign) Bool *%@;",propertyName];
        }else if([NSStringFromClass([value class]) isEqualToString:@"__NSDictionaryI"])  // Nsdictionary
        {
            code = [NSString stringWithFormat:@"@property (nonatomic,strong) NSDictionary *%@;",propertyName];
        }else if([NSStringFromClass([value class]) isEqualToString:@"__NSArrayI"])  // nsarray
        {
            code = [NSString stringWithFormat:@"@property (nonatomic,strong) NSArray *%@;",propertyName];
        }
        codeStr = [NSString stringWithFormat:@"%@\n%@\n",codeStr,code];
    }];
    NSLog(@"codestr = %@",codeStr);
}
@end
