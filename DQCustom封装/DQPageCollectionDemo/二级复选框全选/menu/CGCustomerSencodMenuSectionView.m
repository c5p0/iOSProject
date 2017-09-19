//
//  CGCustomerSencodMenuSectionView.m
//  CenturyGuard
//
//  Created by 世纪阳天 on 16/3/14.
//  Copyright © 2016年 sjyt. All rights reserved.
//

#import "CGCustomerSencodMenuSectionView.h"
@interface CGCustomerSencodMenuSectionView()
@property (nonatomic,assign) BOOL isopen;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *checkBoxWConst;
// 默认 15
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMarginConst;
@end
@implementation CGCustomerSencodMenuSectionView

+ (instancetype)initHeaderView
{
    return  [[[NSBundle mainBundle]loadNibNamed:@"CGCustomerSencodMenuSectionView" owner:nil options:nil]lastObject];
}

- (void)setModel:(id<CGCustomerModelProtocol>)model
{
    _model = model;
    self.gradeLable.text = model.showName;
}
- (IBAction)checkBoxClick:(id)sender {
    self.checkBtn.selected = ![self.checkBtn isSelected];
    if (self.checkBoxBlock) {
        self.checkBoxBlock(self,self.model,self.checkBtn.selected);
    }
}

- (IBAction)downOpenClick:(id)sender {
    if (self.arrowBtnBlock) {
        self.arrowBtnBlock(_model.uiniqueId);
    }
}

- (void)setIsShowCheckBox:(BOOL)isShowCheckBox
{
    _isShowCheckBox = isShowCheckBox;
    if (isShowCheckBox) {
        self.checkBoxWConst.constant = 15;
        self.leftMarginConst.constant = 15;
    }else{
        self.checkBoxWConst.constant = 0;
        self.leftMarginConst.constant = 0;
    }
}
- (void)handleCheckBtn:(CheckBoxClick)block
{
    self.checkBoxBlock = block;
}

- (void)handleArrowBtn:(ArrowBtnClick)block
{
    self.arrowBtnBlock = block;
    
}
@end
