//
//  encryptTool.h
//  DQCustom封装
//  针对加密解密
//  Created by duxiaoqiang on 2017/7/14.
//  Copyright © 2017年 professional. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface encryptTool : NSObject
/**
 *  利用DES加密数据
 *  @param plainText  加密的文本内容
 *  @param key   专有的key  一个钥匙一般
 *  @param iv    可选的初始化向量
 */
+ (NSString *)DESEncryptString:(NSString *)plainText key:(NSString *)key iv:(NSString *)iv;
/**
 *  利用DES解密数据
 */
+ (NSString *)DESDecryptString:(NSString*)cipherText key:(NSString*)key iv:(NSString *)iv;

/**
 MD5加密
 @return 加密后的字符串
 */
+ (NSString *)md5:(NSString *)str;


@end
