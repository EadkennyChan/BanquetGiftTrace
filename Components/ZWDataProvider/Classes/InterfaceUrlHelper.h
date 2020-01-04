//
//  DataProvider.h
//  ZWNetRequestKit
//
//  Created by zwchen on 14/12/27.
//  Copyright (c) 2014年 zwchen. All rights reserved.
//
/*
 *
 *  @brief:服务器接口地址管理类
 *
 *  @create time: 2018-11-06
 *  @update time: 2018-11-06
 *
 *  @description:
 */
#import <Foundation/Foundation.h>

@interface InterfaceUrlHelper : NSObject

@property (nonatomic, copy, readonly)NSString *strBaseUrl;      //接口基地址
@property (nonatomic, copy, readonly)NSString *strBaseArgiUrl;  //农产品接口基地址
@property (nonatomic, copy, readonly)NSString *strBaseH5Url;    //H5页面基地址

/*
 *  正式接口地址
 */
+ (InterfaceUrlHelper *)official;
/*
 *  测试接口地址
 */
+ (InterfaceUrlHelper *)test;
/*
 *  web页面基地址
 *
 *  涉及模块：帮助/客服、
 */
+ (NSString *)baseWebUrl;
/*
 *  官网介绍网址
 *
 *  涉及模块：关于我们、
 */
+ (NSString *)aboutUsWebUrl;

@end
