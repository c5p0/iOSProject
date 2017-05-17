//
//  CGCustomerSecondMenuCell.m
//  SecondMenuDemo
//
//  Created by duxiaoqiang on 2017/5/15.
//  Copyright © 2017年 professional. All rights reserved.
//

#import "CGCustomerSecondMenuCell.h"

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
- (IBAction)checkClick:(id)sender {
    self.checkBtn.selected = ![self.checkBtn isSelected];
    if (self.checkBoxBlock) {
        self.checkBoxBlock(self.model,self.checkBtn.selected);
    }
}

@end
