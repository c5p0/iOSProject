//
//  CGCustomerSecondMenuCell.m
//  SecondMenuDemo
//
//  Created by duxiaoqiang on 2017/5/15.
//  Copyright © 2017年 professional. All rights reserved.
//

#import "CGCustomerSecondMenuCell.h"
#define cornerValue 8
@interface CGCustomerSecondMenuCell()
// 默认为15
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *checkBoxWCOnst;
// 默认为0
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameleftConst;

@end
@implementation CGCustomerSecondMenuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(id<CGCustomerModelProtocol>)model
{
    _model = model;
    self.showNameLabel.text = model.showName;
}

- (void)setIsShowCheckBox:(BOOL)isShowCheckBox
{
    _isShowCheckBox = isShowCheckBox;
    if (isShowCheckBox) {
        self.checkBoxWCOnst.constant = 15;
        self.nameleftConst.constant = 0;
    }else{
        self.checkBoxWCOnst.constant = 0;
        self.nameleftConst.constant = -20;
    }
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    UIBezierPath *path;
    switch (_roundCornerType) {
        case KKRoundCornerCellTypeTop: {
            path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(cornerValue, cornerValue)];
            break;
        }
            
        case KKRoundCornerCellTypeBottom: {
            path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(cornerValue, cornerValue)];
            break;
        }
            
        case KKRoundCornerCellTypeSingleRow: {
            path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(cornerValue, cornerValue)];
            break;
        }
            
        case KKRoundCornerCellTypeDefault:
        default: {
            self.layer.mask = nil;
            return;
        }
    }
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = path.CGPath;
    self.layer.mask = maskLayer;
}

- (void)setIsShowOneMenu:(BOOL)isShowOneMenu
{
    _isShowOneMenu = isShowOneMenu;
    if (isShowOneMenu) {
        self.marginLeftConst.constant = 8;
    }else{
        self.marginLeftConst.constant = 45;
    }
}
- (IBAction)checkClick:(id)sender {
    self.checkBtn.selected = ![self.checkBtn isSelected];
    if (self.checkBoxBlock) {
        self.checkBoxBlock(self.model,self.checkBtn.selected);
    }
}

@end
