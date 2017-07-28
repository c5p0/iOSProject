//
//  NSString+docDir.m
//  01-CoreData
//
//  Created by wu_kong_coo1 on 14-11-17.
//  Copyright (c) 2014年 myCompany. All rights reserved.
//

#import "NSString+Custom.h"
#import <objc/runtime.h>
#import <CommonCrypto/CommonCryptor.h>
#define RGB(r, g, b) [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:1.0f]

@implementation NSString (Custom)

/**
 *  在指定字符串之前追加沙盒文档路径
 *
 *  @return 包含沙盒文档路径的完整文件路径
 */
- (NSString *)appendDocumentDir
{
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    return [docPath stringByAppendingPathComponent:self];
}

/**
 *  在指定字符串之前追加沙盒文档路径的URL
 *
 *  @return 包含沙盒文档路径的完整文件路径的URL/Users/shijiyangtian/Desktop/projectGit/OwnLibraries/CGOwnLibraries/Classes/Foundation+Category/NSString+Custom.m
 */
- (NSURL *)appendDocumentDirURL
{
    return [NSURL fileURLWithPath:[self appendDocumentDir]];
}

- (NSString *)pinYin
{
    NSMutableString *pinyin = [self mutableCopy];
    
    //转换成拼音
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    //去掉音标
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripDiacritics, NO);
    return [pinyin stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (NSString *)translateTStrToTimeString
{
//    2014-08-31T12:11:22.067
    NSString *removePointStr = [self substringToIndex:19];
    return [removePointStr stringByReplacingOccurrencesOfString:@"T" withString:@" "];
}

- (NSString *)translateTStrToTimeString2
{
    return [self substringToIndex:10];
}

- (NSString *)translateTStrToNormalTimeString{
    NSString *tStr = [self translateTStrToTimeString];
    return [tStr substringToIndex:16];
}

- (nonnull NSArray *)rangesOfString:(nonnull NSString *)searchString options:(NSStringCompareOptions)mask locale:(nullable NSLocale *)locale
{
    NSString *sourceStr = [NSString stringWithString:self];
    NSInteger length = sourceStr.length;
    NSRange rangec = NSMakeRange(0, length);
    
    
    NSMutableArray *rangeArr = [NSMutableArray array];
    
    while (rangec.location != NSNotFound) {
        
        rangec = [sourceStr rangeOfString:searchString options:NSCaseInsensitiveSearch range:rangec locale:[NSLocale currentLocale]];
        
        if (rangec.location != NSNotFound) {
            NSRange tRange = rangec;
            NSValue *value = [NSValue valueWithRange:tRange];
            [rangeArr addObject:value];
            NSInteger tLength = length - (tRange.location + tRange.length);
            NSInteger tLocation = tRange.location + tRange.length;
            rangec = NSMakeRange(tLocation, tLength);
            NSLog(@"range:%@", NSStringFromRange(tRange));
        }else{
            break;
        }
    }
    return rangeArr;
}

+ (NSString *)numberTimeChangeStringTime:(NSInteger)bengintime{
    NSString *str = [NSString stringWithFormat:@"%d",bengintime];
    NSString *timeStr = [NSString string];
    if(str.length == 4){
        timeStr = [str substringToIndex:2];
        NSString *tempStr = [NSString string];
        tempStr = [str substringFromIndex:2];
        NSString *format = [NSString stringWithFormat:@":%@",tempStr];
        timeStr = [timeStr stringByAppendingString:format];
    }
    
    if (str.length == 3) {
        NSString *newStr = [NSString stringWithFormat:@"0%d",bengintime];
        timeStr = [newStr substringToIndex:2];
        NSString *tempStr = [NSString string];
        tempStr = [newStr substringFromIndex:2];
        NSString *format = [NSString stringWithFormat:@":%@",tempStr];
        timeStr = [timeStr stringByAppendingString:format];
    }
    
    return timeStr;
}

+ (NSString *)stringDeleteTStringAndOnlyMinute:(NSString *)tempString{
    tempString = [tempString stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    return [tempString substringToIndex:16];
}

+ (NSString *)stringDeleteTStringAndOnlyDay:(NSString *)tempString{
    tempString = [tempString stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    return [tempString substringToIndex:10];
}

+ (NSString *)stringDeleteTStringAndOnlySecends:(NSString *)tempString{
    tempString =  [tempString stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    return [tempString substringToIndex:19];
}

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    NSStringDrawingOptions options = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f) {
        return [self boundingRectWithSize:maxSize
                                  options:options
                               attributes:attrs context:nil].size;
    }
    
    return [self sizeWithFont:font constrainedToSize:maxSize];
}


+ (NSString *)numberStateReturnStringState:(NSInteger)state{
    //  0-正常 1-迟到 2-早退 3-请假 4-缺卡
    switch (state) {
        case 0:
            return @"正常";
            break;
        case 1:
            return @"迟到";
            break;
        case 2:
            return @"早退";
            break;
        case 3:
            return @"请假";
            break;
        case 4:
            return @"缺卡";
            break;
        default:
            break;
    }
    return @"正常";
}

+ (NSString *)formateTenThousand:(NSInteger)number personnalTipsButtonType:(PersonnalTipsButtonType)personnalTipsButtonType
{
    NSString *tempString = [NSString stringWithFormat:@"%ld",(long)number];
    if ([tempString integerValue] >= 10000) {
        tempString = [tempString stringByReplacingCharactersInRange:NSMakeRange(tempString.length - 4, 4) withString:@"万"];
    }
    
    switch (personnalTipsButtonType) {
        case PersonnalTipsButtonTypeIntegral: {
            return [NSString stringWithFormat:@"%@积分",tempString];
            break;
        }
        case PersonnalTipsButtonTypeLoveCoin: {
            return [NSString stringWithFormat:@"%@爱心币",tempString];;
            break;
        }
        case PersonnalTipsButtonTypeGift: {
            return [NSString stringWithFormat:@"%@打赏",tempString];;
            break;
        }
        case PersonnalTipsButtonTypeTask: {
            return [NSString stringWithFormat:@"%@今日任务",tempString];;
            break;
        }
        default: {
            break;
        }
    }
}

+ (NSString *)numberBirthFormateNStringBirth:(NSInteger)birth
{
    if (birth == 0) return @"";
    
    NSString *birth_string = [NSString stringWithFormat:@"%ld",(long)birth];
    NSString *yearString   = [birth_string substringWithRange:NSMakeRange(0, 4)];
    NSString *monthString  = [birth_string substringWithRange:NSMakeRange(4, 2)];
    NSString *dayString    = [birth_string substringWithRange:NSMakeRange(6, 2)];
    
    return [NSString stringWithFormat:@"%@-%@-%@",yearString,monthString,dayString];
    
}

+ (NSInteger)stringBirthFormateNsintegerBirth:(NSString *)bitrh
{
    return  [[bitrh stringByReplacingOccurrencesOfString:@"-" withString:@""] integerValue];
}



+ (NSInteger)sexStringReturnNSInteger:(NSString *)sex
{
    if ([sex isEqualToString:@"1"] || [sex isEqualToString:@"男"]) {
        return 1;
    }else{
        return 0;
    }
    
}

+ (NSString *)genderReturnNSString:(NSInteger)gender
{
    return gender == 1 ? @"男" : @"女";
}

- (BOOL)swizzled_containsString:(NSString *)str
{
    if ([NSString instancesRespondToSelector:@selector(containsString:)] ) {
        return [self swizzled_containsString:str];
    }else{
        NSRange foundRange = [self rangeOfString:str];
        if (foundRange.location != NSNotFound) {
            return YES;
        }else{
            return NO;
        }
    }
}

+ (NSString *)returnTelFormatorNSString:(NSString *)tel
{
    NSRange range = NSMakeRange(3, 4);
    return [tel integerValue] > 0 ? [tel stringByReplacingCharactersInRange:range withString:@"****"] : tel;
}

+ (NSArray *)stringDicArrForContext:(NSString *)context findText:(NSString *)findText
{
    NSMutableString *string = [NSMutableString stringWithString:context];
    NSMutableArray *array = [NSMutableArray array];
    while ([string.lowercaseString rangeOfString:findText.lowercaseString].length) {
        NSRange tempRang = NSMakeRange([string.lowercaseString rangeOfString:findText.lowercaseString].location, [string.lowercaseString rangeOfString:findText.lowercaseString].length);
        [array addObject:[NSValue valueWithRange:tempRang]];
        
        NSMutableString *aa = [NSMutableString string];
        for (int i = 0; i < [string.lowercaseString rangeOfString:findText.lowercaseString].length; i ++) {
            [aa appendString:@"^"];
        }
        [string replaceCharactersInRange:[string.lowercaseString rangeOfString:findText.lowercaseString] withString:aa];
    }
    return array;
}

+ (NSMutableAttributedString *)returnAttributeStringOne:(NSString *)oneS twoS:(NSString *)twoS saveSearchText:(NSString *)saveSearchText
{
    if (twoS.length == 0) {
        twoS = @"";
    }
    
    if (oneS.length == 0) {
        oneS = @"";
    }
    
    NSArray *array1 = [self stringDicArrForContext:oneS findText:saveSearchText];
    NSArray *array2 = [self stringDicArrForContext:twoS findText:saveSearchText];
    NSMutableArray *array3 = [NSMutableArray array];
    for (NSInteger i = 0; i < array2.count ; i++) {
        NSRange tRrang = [array2[i] rangeValue];
        NSRange newRrang = NSMakeRange(tRrang.location + oneS.length + 1, tRrang.length);
        [array3 addObject:[NSValue valueWithRange:newRrang]];
    }
    
    NSMutableArray *allRang = [NSMutableArray array];
    [allRang addObjectsFromArray:array1];
    [allRang addObjectsFromArray:array3];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@(%@)",oneS,twoS]];
    for (NSInteger i= 0; i < allRang.count; i ++) {
        NSRange tRang = [allRang[i] rangeValue];
        [str addAttribute:NSForegroundColorAttributeName value:RGB(255, 153, 0) range:tRang];
    }
    
    return str;
}

+ (NSMutableAttributedString *)returnAttributeStringOne:(NSString *)oneS saveSearchText:(NSString *)saveSearchText
{
    if (oneS.length == 0) {
        oneS = @"";
    }
    NSArray *array1 = [self stringDicArrForContext:oneS findText:saveSearchText];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:oneS];
    for (NSInteger i= 0; i < array1.count; i ++) {
        NSRange tRang = [array1[i] rangeValue];
        [str addAttribute:NSForegroundColorAttributeName value:RGB(255, 153, 0) range:tRang];
    }
    
    return str;
}

+ (NSString *)returnChildNameOrderChilds:(NSArray *)childs
{
    NSString *childsName = @"";
    for (NSDictionary *dic in childs) {
        NSString *real_name = dic[@"real_name"];
        NSString *nick_name = dic[@"nick_name"];
        
        if (real_name == nil) {
            real_name = @"";
        }
        
        if (nick_name == nil) {
            nick_name = @"";
        }
        
        if (real_name && ![real_name isEqualToString:@""]) {
            childsName = [NSString stringWithFormat:@"%@,%@",childsName,real_name];
        }else{
            childsName = [NSString stringWithFormat:@"%@,%@",childsName,nick_name];
        }
    }
    if (childsName.length != 0) {
        childsName = [childsName substringFromIndex:1];
    }
    
    if (childsName.length == 0 || childsName == nil) {
        childsName = @"";
    }
    
    return childsName;
}

void swizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector)
{
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_addMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else{
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (NSString *) encryptUseDES:(NSString *)plainText key:(NSString *)key iv:(NSString *)iv
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


//解密
- (NSString *) decryptUseDES:(NSString*)cipherText key:(NSString*)key iv:(NSString *)iv
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

- (BOOL)containsString:(NSString *)str
{
       if ([self rangeOfString:str].location != NSNotFound) {
            return YES;
        }
        return NO;
}

- (BOOL)isBlankString
{
    if (self == nil || self == NULL)
    {
        return YES;
    }
    if ([self isEqualToString:@"(null)"] || [self isEqualToString:@"<null>"])
    {
        return YES;
    }
    if (self ==(NSString *)[NSNull null])
    {
        return YES;
    }
    if ([self isEqual:@""])
    {
        return YES;
    }else{
       [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]; // 去掉左右两边的空格
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimedString = [self stringByTrimmingCharactersInSet:set];
        
        if ([trimedString length] == 0) {
            return YES;
        }
    }
    
    return NO;
}
- (NSString *)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}
- (NSString *)trimEnhance
{
    NSString *str = self;
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //去除掉首尾的空白字符和换行字符
    str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return str;
}
@end
