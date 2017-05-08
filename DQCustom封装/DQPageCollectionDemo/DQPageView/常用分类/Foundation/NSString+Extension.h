//
//  NSString+Extension.h
//  newDemo
//
//  Created by duxiaoqiang on 16/5/20.
//  Copyright © 2016年 世纪科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>  // 在导入项目过程中如果包含就uikit就可以注释

@interface NSString (Extension)
#pragma mark - 获取沙盒路径拼接
/**
 *  在指定字符串之后追加沙盒文档路径
 *
 *  @return 包含沙盒文档路径的完整文件路径
 */
- (NSString *)appendDocumentDir;

/**
 *  在指定字符串之前追加沙盒文档路径的URL
 *
 *  @return 包含沙盒文档路径的完整文件路径的URL
 */
- (NSURL *)appendDocumentDirURL;

#pragma mark - 手机、邮箱、车牌号等格式验证
/**
 *  匹配该字符串是否是手机号码格式
 *
 *  @return 返回YES 是手机号码，返回NO  不是手机号码
 */
- (BOOL)matchTelPhone;
/**
 *  匹配该字符串是否是邮箱
 *
 *  @return  返回YES 是邮箱格式，返回NO  不是邮箱格式
 */
- (BOOL)matchEmail;
/**
 *  匹配字符串是车牌号
 *
 *  @return 返回
 */
- (BOOL)matchCarNo;

#pragma mark - emoji的一些判断

/**
 *  字符串转换成emojicode
 *
 *  @return emoji
 */
- (NSString *)emoji;

/**
 *  是否为emoji字符
 */
- (BOOL)isEmoji;


#pragma mark - 其他
/**
 *  把汉字转换成拼音
 *
 *  @return 转换成拼音后的字符串
 */
- (NSString *)converToPinYin;

/**
 *  给定字符串的字体和最大宽度计算出字符串的size
 *  @param font 字符串的字体
 *  @param maxW 计算显示最大的宽度
 *  @return 计算之后的size
 */
- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW;

/**
 *  计算当前文件\文件夹的内容大小
 */
- (NSInteger)fileSize;

- (NSString *)md5;

@end
