//
//  DataProvider.m
//  ZWNetRequestKit
//
//  Created by 陈正旺 on 14/12/27.
//  Copyright (c) 2014年 zwchen. All rights reserved.
//

#import "InterfaceUrlHelper.h"
#import "DataProvider.h"
#import "dataUrl.h"

@interface InterfaceUrlHelper()
{
    NSString *m_strUrl;
    NSString *m_strArgiUrl;
    NSString *m_strH5Url;
}
@end

@implementation InterfaceUrlHelper

- (NSString *)strBaseUrl
{
    return m_strUrl;
}

- (NSString *)strBaseArgiUrl
{
    return m_strArgiUrl;
}

- (NSString *)strBaseH5Url
{
    return m_strH5Url;
}

+ (InterfaceUrlHelper *)official
{
    InterfaceUrlHelper *interface = [[InterfaceUrlHelper alloc] init];
    interface->m_strUrl = URL_INTERFACE_OFFICIAL;
    interface->m_strArgiUrl = URL_INTERFACE_OFFICIAL;
    interface->m_strH5Url = URL_H5_DOMAIN_OFFICIAL;
    return interface;
}

+ (InterfaceUrlHelper *)test
{
    InterfaceUrlHelper *interface = [[InterfaceUrlHelper alloc] init];
    interface->m_strUrl = URL_INTERFACE_TEST;
    interface->m_strArgiUrl = URL_INTERFACE_Argi_TEST;
    interface->m_strH5Url = URL_H5_DOMAIN_TEST;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *strUrl = [userDefaults stringForKey:@"server_address"];
    if (strUrl.length > 0)
    {
        interface->m_strUrl = strUrl;
    }
    else
    {
        [userDefaults setValue:interface->m_strUrl forKey:@"server_address"];
        [userDefaults synchronize];
    }
    
    return interface;    
}

+ (NSString *)baseWebUrl
{
    NSString *strBundleID = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleIdentifierKey];
    if ([strBundleID isEqualToString:@"cn.com.a-b.app.supercode"])//正式版
    {
        if (![DataProvider shareInstance].isTestVersion)
        {
            return @"https://appwap.app315.net/";
        }
    }
    return @"http://122.224.171.198/appwap/";
}

+ (NSString *)aboutUsWebUrl
{
    NSString *strBundleID = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleIdentifierKey];
    if ([strBundleID isEqualToString:@"cn.com.a-b.app.supercode"])//正式版
    {
        if (![DataProvider shareInstance].isTestVersion)
        {
            return @"https://www.app315.net/superCode?id=68a5a9fe-3b46-4f5b-8baa-64a68e7b6a37";
        }
    }
    return @"http://122.224.171.198/GuanWangWap/SuperCode.aspx?phone=ios";
}

@end
