//
//  encryptTool.m
//  DQCustom封装
//
//  Created by duxiaoqiang on 2017/7/14.
//  Copyright © 2017年 professional. All rights reserved.
//

#import "encryptTool.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCrypto.h>
@implementation encryptTool
+ (NSString *)DESEncryptString:(NSString *)plainText key:(NSString *)key iv:(NSString *)iv
{
    NSString *ciphertext = nil;
    const char *textBytes = [plainText UTF8String];
    NSUInteger dataLength = [plainText length];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String], kCCKeySizeDES,
                                          [iv UTF8String],
                                          textBytes,
                                          dataLength,
                                          &buffer,
                                          1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        ciphertext = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    }
    return ciphertext;
}

+ (NSString *)DESDecryptString:(NSString*)cipherText key:(NSString*)key iv:(NSString *)iv
{
    NSData* cipherData = [[NSData alloc]initWithBase64EncodedString:cipherText options:NSDataBase64DecodingIgnoreUnknownCharacters];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String],
                                          kCCKeySizeDES,
                                          [iv UTF8String],
                                          [cipherData bytes],
                                          [cipherData length],
                                          buffer,
                                          1024,
                                          &numBytesDecrypted);
    NSString* plainText = nil;
    if (cryptStatus == kCCSuccess) {
        NSData* data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
        plainText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return plainText;
}

+ (NSString *)md5:(NSString *)str
{
    const char *data = str.UTF8String;
        
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
        
    CC_MD5(data, (CC_LONG)strlen(data), digest);
        
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
        
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i ++) {
        [result appendFormat:@"%02x", digest[i]];
    }
        
    return result;
}
@end
