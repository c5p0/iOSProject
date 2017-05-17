//
//  CGCustomerModelProtocol.h
//  SecondMenuDemo
//
//  Created by duxiaoqiang on 2017/5/15.
//  Copyright © 2017年 professional. All rights reserved.
//

@protocol CGCustomerModelProtocol <NSObject>

@required
/** 显示的文字 */
@property (nonatomic,copy, readonly) NSString * showName;
/** 用来唯一性的id*/
@property (nonatomic, readonly) NSInteger uiniqueId ;
@end
