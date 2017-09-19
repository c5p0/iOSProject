//
//  CGCustomerSecondMenuCell.h
//  SecondMenuDemo
//
//  Created by duxiaoqiang on 2017/5/15.
//  Copyright © 2017年 professional. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGCustomerModelProtocol.h"
typedef NS_ENUM(NSInteger,RoundCornerType)
{
    KKRoundCornerCellTypeDefault = 0,
    KKRoundCornerCellTypeTop,
    KKRoundCornerCellTypeBottom,
    KKRoundCornerCellTypeSingleRow,
};
typedef void(^checkBoxClick) (id<CGCustomerModelProtocol> model,BOOL isChecked);
@interface CGCustomerSecondMenuCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet UILabel *showNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *showCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *scrollLine;
@property (nonatomic,copy) checkBoxClick checkBoxBlock;
@property (nonatomic,strong) id<CGCustomerModelProtocol> model;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *marginLeftConst;
@property (nonatomic,assign) BOOL isShowOneMenu ;   // 是否一级菜单
@property (nonatomic,assign) NSInteger roundCornerType ;
@property (nonatomic,assign) BOOL isShowCheckBox ;
@end
