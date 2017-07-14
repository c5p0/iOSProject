//
//  CGMatchConst.m
//  InputKitDemo
//
//  Created by tingxins on 05/06/2017.
//  Copyright © 2017 tingxins. All rights reserved.
//

#import "CGMatchConst.h"

NSString * const kCGLimitedTextFieldNumberOnlyRegex = @"^[0-9]*$";
NSString * const kCGLimitedTextFieldZeroOrNonRegex = @"^(0|[1-9][0-9]*)$";
NSString * const kCGLimitedTextFieldChineseOnlyRegex = @"^[\u4e00-\u9fa5]{0,}$";
NSString * const kCGLimitedTextFieldEnglishOnlyRegex = @"^[A-Za-z]+$";
