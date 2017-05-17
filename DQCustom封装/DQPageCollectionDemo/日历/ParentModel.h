//
//  ParentModel.h
//  SecondMenuDemo
//
//  Created by duxiaoqiang on 2017/5/15.
//  Copyright © 2017年 professional. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CGCustomerModelProtocol.h"
#import "ChildModel.h"
@interface ParentModel : NSObject<CGCustomerModelProtocol>
/** 显示的文字 */
@property (nonatomic, copy) NSString * showName;
/** 用来区分类别唯一性的id*/
@property (nonatomic, assign) NSInteger uiniqueId ;
@property (nonatomic,strong)  NSMutableArray *childs;
@end
