//
//  CGExpressionTextView.m
//  CenturyGuard
//
//  Created by 黄国刚 on 2016/10/9.
//  Copyright © 2016年 sjyt. All rights reserved.
//

#import "CGExpressionTextView.h"

@implementation CGTextAttachment

@end

@interface CGExpressionTextView () <UITextViewDelegate>
{
    CGFloat H;
    CGFloat textView_H;
    UILabel *_placeholderLabel;
    BOOL _isFinish;  // 是否已经完成输入，防止重新init后又走didchange方法改变
    CGFloat _fontSize;
}

@end

@implementation CGExpressionTextView

#pragma mark -
#pragma mark - 初始化
//初始化
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

//同上
-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self initView];
}

- (void)initView
{
    self.bounces = NO;
    
    textView_H = self.bounds.size.height;
    self.delegate = self;
    
    // 设置最大允许输入字数的默认值
    if (self.maxTextCount == 0)
    {
        self.maxTextCount = 120;
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview) {
        //添加通知
        _fontSize = self.font.pointSize;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChanged:) name:UITextViewTextDidChangeNotification object:self];
    }else{
        //移除通知
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

//添加占位文字
- (void)setPlaceHolder:(NSString *)placeHolder
{
    _placeHolder = placeHolder;
    
    float left=5,top=2,hegiht=30;
    
    UIColor *placeholderColor = [UIColor colorWithWhite:0.6 alpha:0.7];
    
    if (!_placeholderLabel)
    {
        _placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(left, top
                                                                      , CGRectGetWidth(self.frame)-2*left, hegiht)];
        _placeholderLabel.textColor = placeholderColor;
        _placeholderLabel.font = self.font;
        [self addSubview:_placeholderLabel];
    }
    _placeholderLabel.text = placeHolder;
    _placeholderLabel.hidden = self.attributedText.length;
}

- (NSString *)finished
{
    return [[self class] attributeStringToExceptionStr:self.attributedText];
}

- (void)initAttStr
{
    self.attributedText = nil;
    self.text = @"";
    
    [self textDidChanged:nil];
}

#pragma mark -
#pragma mark - 文本改变
- (void)textDidChanged:(NSNotification *)notif
{
    self.font = [UIFont systemFontOfSize:_fontSize];
    
    UITextRange *selectedRange = [self markedTextRange];
    //获取高亮部分
    UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    
    if ([self finished].length > _maxTextCount && !position)
    {
        while ([self finished].length > _maxTextCount)
        {
            self.attributedText = [self.attributedText attributedSubstringFromRange:NSMakeRange(0, self.attributedText.length - 1)];
        }
    }
    
    _placeholderLabel.hidden = self.attributedText.length;
    
    if ([self.expressionDelegate respondsToSelector:@selector(CGExpressionTextViewDidChanged:textLength:)])
    {
        
        NSInteger length = [[self finished] stringByTrimmingCharactersInSet:
                            [NSCharacterSet whitespaceAndNewlineCharacterSet]].length;
        
        [self.expressionDelegate CGExpressionTextViewDidChanged:self textLength:length];
    }
    
    CGSize contentSize = self.contentSize;
    if (contentSize.height > (self.maxHeight == 0 ? 200 : self.maxHeight)) {
        
        if (self.bounds.size.height <  (self.maxHeight == 0 ? 200 : self.maxHeight) - 2) {
            if ([self.expressionDelegate respondsToSelector:@selector(CGExpressionTextViewDidChangeH:H:isFinish:)]) {
                [self.expressionDelegate CGExpressionTextViewDidChangeH:self H:self.maxHeight == 0 ? 200 : self.maxHeight isFinish:_isFinish];
            }
        }
        
        if (self.scrollEnabled) {
            [self scrollRangeToVisible:NSMakeRange(self.attributedText.length, 1)];
        }
        return;
    }
    
    if (H == 0) {
        H = contentSize.height;
        
        if (self.scrollEnabled)
        {
            [self setContentOffset:CGPointZero animated:YES];
        }
        
        if (H - self.bounds.size.height < 5)
        {
            return;
        }
        
        if ([self.expressionDelegate respondsToSelector:@selector(CGExpressionTextViewDidChangeH:H:isFinish:)]) {
            [self.expressionDelegate CGExpressionTextViewDidChangeH:self H:H isFinish:_isFinish];
        }
        
        return;
    }
    
    if (self.bounds.size.height >= H && self.bounds.size.height == textView_H) {
        H = contentSize.height;
    }
    
    if (H != contentSize.height) {
        CGRect frame = self.frame;
        CGFloat height = frame.size.height + (contentSize.height - H);
        if (height < textView_H) {
            height = textView_H;
        }
        H = contentSize.height;
        
        if ([self.expressionDelegate respondsToSelector:@selector(CGExpressionTextViewDidChangeH:H:isFinish:)])
        {
            [self.expressionDelegate CGExpressionTextViewDidChangeH:self H:height isFinish:_isFinish];
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
            [self setContentOffset:CGPointZero animated:YES];
        }];
    }
}

#pragma mark -
#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([self.expressionDelegate respondsToSelector:@selector(CGExpressionTextViewShouldBeginInput:)]) {
        [self.expressionDelegate CGExpressionTextViewShouldBeginInput:self];
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([self.expressionDelegate respondsToSelector:@selector(CGExpressionTextViewShouldEndInput:)])
    {
        [self.expressionDelegate CGExpressionTextViewShouldEndInput:self];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        
        if ([self.expressionDelegate respondsToSelector:@selector(CGExpressionTextViewDidPressReturn:text:)]) {
            [self.expressionDelegate CGExpressionTextViewDidPressReturn:self text:[self finished]];
        }
        
        if (self.endEditIsNotClear == NO)
        {
            NSInteger length = [[self finished] stringByTrimmingCharactersInSet:
                                [NSCharacterSet whitespaceAndNewlineCharacterSet]].length;
            if (length)
            {
                [self initAttStr];
            }
        }
        
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    if ([text isEqualToString:@"\r\r"]) {
        return NO;
    }
    
    return YES;
}

- (void)inputExpressionWithImageName:(NSString *)imageName hanziText:(NSString *)hanziText
{
    if ([self finished].length + hanziText.length > self.maxTextCount && !([hanziText isEqualToString:@"删除"] || [hanziText isEqualToString:@"发送"]))
    {
        return;
    }
    
    NSRange signRange = self.selectedRange;
    
    if ([hanziText isEqualToString:@"删除"]) {
        if (self.attributedText.length > 0) {
            
            if (signRange.location == 0) {
                return;
            }else{
                
                NSMutableAttributedString *str = [self.attributedText mutableCopy];
                [str deleteCharactersInRange:NSMakeRange(signRange.location - 1, 1)];
                self.attributedText = str;
                [self textDidChanged:nil];
            }
        }
    }else if ([hanziText isEqualToString:@"发送"]){
        
        if ([self.expressionDelegate respondsToSelector:@selector(CGExpressionTextViewDidPressReturn:text:)])
        {
            [self.expressionDelegate CGExpressionTextViewDidPressReturn:self text:[self finished]];
        }
        
        if (self.endEditIsNotClear == NO)
        {
            NSInteger length = [[self finished] stringByTrimmingCharactersInSet:
                                [NSCharacterSet whitespaceAndNewlineCharacterSet]].length;
            if (length)
            {
                [self initAttStr];
            }
        }
        
        _isFinish = YES;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _isFinish = NO;
        });
    }else{
        UIImage *image = [UIImage imageNamed:imageName];
        
        //图片转换为富文本，进行替换
        if (image) {
            CGTextAttachment *textAttachment = [CGTextAttachment new];
            textAttachment.image = image;
            textAttachment.hanzi = hanziText;
            textAttachment.bounds = CGRectMake(0, - 14 / 3, 14 * 1.3, 14 * 1.3);
            NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
            
            NSMutableAttributedString *str = [self.attributedText mutableCopy];
            [str insertAttributedString:imageStr atIndex:self.selectedRange.location];
            self.attributedText = str;
            [self textDidChanged:nil];
        }
    }
    
    if ([hanziText isEqualToString:@"删除"]) {
        self.selectedRange = NSMakeRange(signRange.location - 1, 0);
    }else{
        self.selectedRange = NSMakeRange(signRange.location + 1, 0);
    }
}

#pragma mark -
#pragma mark - 复制，剪切，文本转换

- (void)copy:(id)sender
{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    
    if (self.attributedText.length)
    {
        pboard.string = [CGExpressionTextView attributeStringToExceptionStr:self.attributedText];
    }
    else
    {
        pboard.string = self.text;
    }
}

- (void)cut:(id)sender
{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    
    if (self.attributedText.length)
    {
        NSAttributedString *sign = [self.attributedText attributedSubstringFromRange:self.selectedRange];
        
        NSRange range = self.selectedRange;
        
        NSMutableAttributedString *str = [self.attributedText mutableCopy];
        [str deleteCharactersInRange:self.selectedRange];
        self.attributedText = str;
        
        self.selectedRange = NSMakeRange(range.location, 0);
        
        [self textDidChanged:nil];
        
        
        pboard.string = [CGExpressionTextView attributeStringToExceptionStr:sign];
    }
    else
    {
        [super cut:sender];
    }
}

- (void)paste:(id)sender
{
    NSRange range = self.selectedRange;
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    
    NSMutableAttributedString *cutStr = [self.attributedText mutableCopy];
    [cutStr deleteCharactersInRange:self.selectedRange];
    self.attributedText = cutStr;
    
    self.selectedRange = NSMakeRange(range.location, 0);
    
    NSMutableAttributedString *str = [self.attributedText mutableCopy];
    [str insertAttributedString:[[self class] exceptionStrToAttributeString:pboard.string fontSize:_fontSize] atIndex:self.selectedRange.location];
    
    self.attributedText = str;
    
    self.selectedRange = NSMakeRange(range.location + [[self class] exceptionStrToAttributeString:pboard.string fontSize:_fontSize].length, 0);
    
    [self textDidChanged:nil];
}

+ (NSMutableAttributedString *)exceptionStrToAttributeString:(NSString *)exceptionStr fontSize:(CGFloat)fontSize
{
    if (exceptionStr.length == 0) {
        return [NSMutableAttributedString new];
    }
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:exceptionStr];
    [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontSize] range:NSMakeRange(0, attStr.length)];
    
    NSError *error = nil;
    NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:@"\\[[a-zA-Z0-9\u4e00-\u9fa5]+\\]" options:NSRegularExpressionCaseInsensitive error:&error];
    if (!re) {
        NSLog(@"%@", [error localizedDescription]);
    }
    NSArray *arr = [re matchesInString:exceptionStr options:0 range:NSMakeRange(0, [exceptionStr length])];
    
    
    
    //汉语与图片名对应
    NSString * fileSavePath = [[NSBundle mainBundle] pathForResource:@"ExpressionNameList" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:fileSavePath];
    
    for (NSInteger i = arr.count - 1; i >= 0; i --) {
        NSTextCheckingResult *result = [arr objectAtIndex:i];
        NSRange resultRange = [result rangeAtIndex:0];
        
        NSString *hanzi = [exceptionStr substringWithRange:resultRange];
        NSString *imageName = [NSString stringWithFormat:@"%@.png", [dic objectForKey:hanzi]];
        UIImage *image = [UIImage imageNamed:imageName];
        
        //图片转换为富文本，进行替换
        if (image) {
            CGTextAttachment *textAttachment = [CGTextAttachment new];
            textAttachment.image = image;
            textAttachment.hanzi = hanzi;
            textAttachment.bounds = CGRectMake(0, - fontSize / 3, fontSize * 1.3, fontSize * 1.3);
            NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
            [attStr replaceCharactersInRange:resultRange withAttributedString:imageStr];
        }
    }
    
    return attStr;
}

/**
 富文本转图片文字文本:[笑]
 @param exceptionStr 富文本
 @return 图片文字文本
 */
+ (NSString *)attributeStringToExceptionStr:(NSAttributedString *)exceptionStr
{
    NSMutableString *text = [NSMutableString string];
    [exceptionStr enumerateAttributesInRange:NSMakeRange(0, exceptionStr.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        CGTextAttachment *att = [attrs objectForKey:@"NSAttachment"];
        if (att) {
            if ([att isKindOfClass:[CGTextAttachment class]])
            {
                [text appendString:att.hanzi];
            }
        }else{
            NSAttributedString *str = [exceptionStr attributedSubstringFromRange:range];
            NSString *string = str.string;
            [text appendString:string];
        }
    }];
    return text;
}

// 中文名与图片名互转
- (NSString *)ExceptionNameChangeImageName:(NSString *)str
{
    NSString * fileSavePath = [[NSBundle mainBundle] pathForResource:@"ExpressionNameList" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:fileSavePath];
    
    return [dic objectForKey:str] ? [dic objectForKey:str] : @"删除";
}

@end
