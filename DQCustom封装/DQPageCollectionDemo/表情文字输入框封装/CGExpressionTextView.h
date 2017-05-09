//
//  CGExpressionTextView.h
//  CenturyGuard
//
//  Created by 黄国刚 on 2016/10/9.
//  Copyright © 2016年 sjyt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CGTextAttachment : NSTextAttachment

@property (nonatomic, strong) NSString *hanzi;

@end

@class CGExpressionTextView;
@protocol  CGExpressionTextViewDelegate <NSObject>
@optional


/**
 *  更改高度后
 *
 *  @param calendar calendar description
 *  @param H        改变后的高度
 */
- (void)CGExpressionTextViewDidChangeH:(CGExpressionTextView *)calendar H:(CGFloat)H isFinish:(BOOL)isFinish;

/**
 *  点击return键
 *
 *  @param calendar calendar description
 *  @param text     文本信息
 */
- (void)CGExpressionTextViewDidPressReturn:(CGExpressionTextView *)calendar text:(NSString *)text;

/**
 *  开始输入
 *
 *  @param calendar calendar description
 */
- (void)CGExpressionTextViewShouldBeginInput:(CGExpressionTextView *)calendar;

/**
 *  结束输入
 *
 *  @param calendar calendar description
 */
- (void)CGExpressionTextViewShouldEndInput:(CGExpressionTextView *)calendar;

/**
 *  文本改变后，主要用于改变表情界面“发送”按钮的状态
 *
 *  @param calendar calendar description
 *  @param textLength     文本信息长度
 */
- (void)CGExpressionTextViewDidChanged:(CGExpressionTextView *)calendar textLength:(NSInteger)textLength;

@end



@interface CGExpressionTextView : UITextView

@property (nonatomic, weak) id <CGExpressionTextViewDelegate> expressionDelegate;
/**
 *  占位符
 */
@property (nonatomic, strong) NSString *placeHolder;
/**
 *  最大高度，针对聊天输入框等需要改变高度的输入框
 */
@property (nonatomic, assign) CGFloat maxHeight;
/**
 *  最大允许输入的文本长度,默认800字
 */
@property (nonatomic, assign) NSInteger maxTextCount;

/**
 完成输入后是否不清空，默认自动清空
 */
@property (nonatomic, assign) BOOL endEditIsNotClear;

/**
 *  输入表情文本
 *
 *  @param imageName 图片名字
 *  @param hanziText     图片中文名
 */
- (void)inputExpressionWithImageName:(NSString *)imageName hanziText:(NSString *)hanziText;

/**
 *  完成输入
 *
 *  @return  回调输入的文本
 */
- (NSString *)finished;

/**
 *  结束输入后重新初始化显示文本
 */
- (void)initAttStr;


/**
 图片文字转富文本

 @param exceptionStr 图片文字:[笑]
 @param fontSize 字体大小
 @return 富文本
 */
+ (NSMutableAttributedString *)exceptionStrToAttributeString:(NSString *)exceptionStr fontSize:(CGFloat)fontSize;

/**
 富文本转图片文字文本:[笑]
 @param exceptionStr 富文本
 @return 图片文字文本
 */
+ (NSString *)attributeStringToExceptionStr:(NSAttributedString *)exceptionStr;

@end
