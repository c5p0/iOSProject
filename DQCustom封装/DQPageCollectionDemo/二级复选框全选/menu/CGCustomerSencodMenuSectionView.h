//
//  CGCustomerSencodMenuSectionView.h
//  CenturyGuard
//
//  Created by 世纪阳天 on 16/3/14.
//  Copyright © 2016年 sjyt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGCustomerModelProtocol.h"
@class CGCustomerSencodMenuSectionView;
typedef void(^CheckBoxClick) (CGCustomerSencodMenuSectionView * sectionView,id<CGCustomerModelProtocol> model,BOOL isCheck);
typedef void(^ArrowBtnClick) (NSInteger uiqueId);
@interface CGCustomerSencodMenuSectionView : UIView
+ (instancetype)initHeaderView;

@property (weak, nonatomic) IBOutlet UIImageView *arrowIV;
@property (weak, nonatomic) IBOutlet UILabel *gradeLable;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (nonatomic,copy) CheckBoxClick checkBoxBlock;
@property (nonatomic,copy) ArrowBtnClick arrowBtnBlock;
@property (nonatomic,strong) id<CGCustomerModelProtocol> model;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (nonatomic,assign) NSInteger section;
@property (nonatomic,assign) BOOL isShowCheckBox;

- (void)handleCheckBtn:(CheckBoxClick)block;
- (void)handleArrowBtn:(ArrowBtnClick)block;
@end
