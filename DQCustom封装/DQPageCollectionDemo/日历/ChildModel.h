//
//  ChildModel.h
//  SecondMenuDemo
//
//  Created by duxiaoqiang on 2017/5/15.
//  Copyright © 2017年 professional. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CGCustomerModelProtocol.h"
@interface ChildModel : NSObject<CGCustomerModelProtocol>
/** 显示的文字 */
@property (nonatomic, copy) NSString * showName;
/** 用来区分类别唯一性的id*/
@property (nonatomic, assign) NSInteger uiniqueId ;
@property (nonatomic,copy) NSString *nickName;
@end
