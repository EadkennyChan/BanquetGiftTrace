//
//  DataProvider.h
//  ZWNetRequestKit
//
//  Created by 陈正旺 on 14/12/27.
//  Copyright (c) 2014年 zwchen. All rights reserved.
//
/*
 *
 *  @brief:网络数据请求部分
 *
 *  @create time: 2014-12-27
 *  @update time: 2017-04-06
 *
 *  @description:
 */
#import <Foundation/Foundation.h>
#import "InterfaceUrlHelper.h"
#import <CoreLocation/CoreLocation.h>
#import "JSONKit.h"

_Pragma("clang diagnostic push")
_Pragma("clang diagnostic ignored \"-Wmacro-redefined\"")

#define NumPerPage  20
//#define OfficialVersion

/*
 *  @brief: 数据返回的格式： {
 *                            "Result": "200",
 *                            "Error": "",
 *                            "Data":
 *                        }
 *
 */
UIKIT_EXTERN NSString *_Nonnull const g_strResultCodeKey;
UIKIT_EXTERN NSString *_Nonnull const g_strResultMessageKey;
UIKIT_EXTERN NSString *_Nonnull const g_strResultDataKey;

UIKIT_EXTERN NSString *_Nonnull const kMSG_RELOGIN;

@interface DataProvider : NSObject

+ (nonnull instancetype)shareInstance;

@property (nonatomic, assign)CGFloat fTimeOutDuration;//网络请求超时时间，默认60s
@property (nonatomic, retain, readonly, nonnull)NSString *strDefaultInterfaceVersion;//默认的接口请求版本

@property (nonatomic, assign, readonly)BOOL isTestVersion;

@property (nonatomic, retain, nonnull)InterfaceUrlHelper *service;//服务器接口
/**
 获取接口url地址
 @param strFunction 接口名称
 @return 拼接好的接口url
 */
- (nonnull NSString *)baseUrl:(nonnull NSString *)strFunction;
/**
 获取农产品接口url地址
 @param strFunction 接口名称
 @return 拼接好的接口url
 */
- (nonnull NSString *)argiBaseUrl:(nonnull NSString *)strFunction;

+ (NSInteger)getCodeFromResult:(nonnull NSDictionary *)dicData;
+ (nullable NSString *)getMsgFromResult:(nonnull NSDictionary *)dicData;
+ (nullable NSDictionary *)getDataFromResult:(nonnull NSDictionary *)dicData;

- (void)dataTaskWithParam:(nullable NSDictionary *)dicParam url:(nonnull NSString *)strUrl handler:(nullable BlockBoolStrObject)completionHandler;
- (void)dataTaskByGet:(nullable NSDictionary *)dicParam url:(nonnull NSString *)strUrl handler:(nullable BlockBoolStrObject)completionHandler;
- (void)dataTaskByPost:(nullable NSDictionary *)dicParam url:(nonnull NSString *)strUrl handler:(nullable BlockBoolStrObject)completionHandler;
/**
 上传图片数据
 @param dicParam
 @param arrayDatas 图片数据数组，数组中每项都是一个字典，字典内包含imageData、imageKey
 @param strUrl 接口地址
 @param blockUploadProgress 进度回调
 @param completionHandler 完成回调
 */
- (void)dataTaskUpload:(nullable NSDictionary *)dicParam imageDatas:(nullable NSArray<NSDictionary *> *)arrayDatas url:(nonnull NSString *)strUrl progress:(nullable BlockObject)blockUploadProgress handler:(nullable BlockBoolStrObject)completionHandler;
@end

#pragma mark -

void addPageParam(NSMutableDictionary *_Nonnull mtDic, NSInteger nCurPage);
void addPageParamUpper(NSMutableDictionary *_Nonnull mtDic, NSInteger nCurPage);
void addLoactionParam(NSMutableDictionary *_Nonnull mtDic);
void addLoginToken(NSMutableDictionary *_Nonnull mtDic);
void addUserName(NSMutableDictionary *_Nonnull mtDic);
void addUserID(NSMutableDictionary *_Nonnull mtDic);
void addClientFlag(NSMutableDictionary *_Nonnull mtDic);
void addInterfaceVersion(NSMutableDictionary *_Nonnull mtDic);
