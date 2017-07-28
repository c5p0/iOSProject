//
//  NSString+docDir.h
//  01-CoreData
//
//  Created by wu_kong_coo1 on 14-11-17.
//  Copyright (c) 2014年 myCompany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,PersonnalTipsButtonType) {
    PersonnalTipsButtonTypeIntegral = 0, // 积分
    PersonnalTipsButtonTypeLoveCoin = 1, // 爱心币
    PersonnalTipsButtonTypeGift     = 2, // 礼物
    PersonnalTipsButtonTypeTask     = 3, // 今日任务
};


@interface NSString (Custom)

/**
 *  在指定字符串之前追加沙盒文档路径
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

#pragma mark - PinYin

- (NSString *)pinYin;

/**
 *  2014-08-31T12:11:22.067 ->2014-08-31 12:11:22
 *
 *  @return 标准时间格式字符串
 */
- (NSString *)translateTStrToTimeString;

/**
 *  2014-08-31T12:11:22.067 ->2014-08-31
 *
 *  @return 2014-08-31
 */
- (NSString *)translateTStrToTimeString2;

/**
 *  2014-08-31 12:11:22
 *
 *  @return 2014-08-31 12:11
 */
- (NSString *)translateTStrToNormalTimeString;

#pragma mark - range

/**
 *  获取searchString在消息接受者所有符合range数组，封装为NSValue
 *
 *  @param searchString 子串
 *  @param mask         匹配模式
 *  @param locale
 *
 *  @return NSValue 数组
 */
- (nonnull NSArray *)rangesOfString:(nonnull NSString *)searchString options:(NSStringCompareOptions)mask locale:(nullable NSLocale *)locale;

#pragma mark - time

+ (NSString *)numberTimeChangeStringTime:(NSInteger)bengintime;

/**
 *  根据返回的时间 去掉T 并且只是精确到分钟
 */
+ (NSString *)stringDeleteTStringAndOnlyMinute:(NSString *)tempString;
/**
 *  根据返回的时间 去掉T 并且只是精确到天
 */
+ (NSString *)stringDeleteTStringAndOnlyDay:(NSString *)tempString;

+ (NSString *)stringDeleteTStringAndOnlySecends:(NSString *)tempString;
/**
 *  计算字体占据多大范围
 *
 *  @param font    字体大小
 *  @param maxSize 最大size
 *
 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

/**
 *  根据返回的 数字状态 返回 字符状态
 */
+ (NSString *)numberStateReturnStringState:(NSInteger)state;



+ (NSString *)formateTenThousand:(NSInteger)number personnalTipsButtonType:(PersonnalTipsButtonType)personnalTipsButtonType;

/**
 *  根据数字类型19910101 ---> 1991-01-01
 */
+ (NSString *)numberBirthFormateNStringBirth:(NSInteger)birth;
/**
 *  根据数字类型19910101 ---> 19910101
 */
+ (NSInteger)stringBirthFormateNsintegerBirth:(NSString *)bitrh;
/**
 *  更新男女 返回 1 0
 */
+ (NSInteger)sexStringReturnNSInteger:(NSString *)sex;

/**
 *  更新男女 返回 1 0
 */
+ (NSString *)genderReturnNSString:(NSInteger)gender;

+ (NSString *)returnChildNameOrderChilds:(NSArray *)childs;
/**
 *  返回138****8888格式号码
 */
+ (NSString *)returnTelFormatorNSString:(NSString *)tel;

+ (NSMutableAttributedString *)returnAttributeStringOne:(NSString *)oneS twoS:(NSString *)twoS saveSearchText:(NSString *)saveSearchText;

+ (NSMutableAttributedString *)returnAttributeStringOne:(NSString *)oneS saveSearchText:(NSString *)saveSearchText;

- (BOOL)swizzled_containsString:(NSString *)str;
/**
 *  判断字符串是否为空
 */
- (BOOL)isBlankString;
/**
 *  DES加密
 *
 *  @param plainText 明文
 *  @param key       key
 *  @param iv        iv
 *
 *  @return 加密后结果
 */
- (NSString *) encryptUseDES:(NSString *)plainText key:(NSString *)key iv:(NSString *)iv;
/**
 *  DES解密
 *
 *  @param cipherText 密文
 *  @param key        key
 *  @param iv         iv
 *
 *  @return 解密后字符
 */
- (NSString *) decryptUseDES:(NSString*)cipherText key:(NSString*)key iv:(NSString *)iv;

/**
 *  解决ios7 下不存在containsString方法的情况
 *
 */
- (BOOL)containsString:(NSString *)str;


/**
 去除字符串左右两边空格
 */
- (NSString *)trim;

/**
 去除字符串左右两边空格和回车换行

 @return 去除后的字符串
 */
- (NSString *)trimEnhance;
@end

NS_ASSUME_NONNULL_END
