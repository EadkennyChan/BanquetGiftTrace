//
//  DataProvider.m
//  ZWNetRequestKit
//
//  Created by 陈正旺 on 14/12/27.
//  Copyright (c) 2014年 zwchen. All rights reserved.
//

#import "DataProvider.h"
#import <Foundation/NSJSONSerialization.h>
#import "JSONKit.h"
#import "AFNetworking.h"

#pragma mark - 全局变量定义

NSString *const g_strResultCodeKey = @"Result";
NSString *const g_strResultMessageKey = @"Error";
NSString *const g_strResultDataKey = @"Data";

NSString *const kMSG_RELOGIN = @"kMSG_RELOGIN";

#pragma mark -

NS_CLASS_AVAILABLE_IOS(7_0)
@interface DataProvider ()

@property (nonatomic, retain)NSURLSessionTask *taskCurrent;

@end

@implementation DataProvider

+ (instancetype)shareInstance
{
    static dispatch_once_t once;
    static DataProvider *sharedRequest;
    dispatch_once(&once, ^{sharedRequest = [[self alloc] init];});
    return sharedRequest;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
#ifdef OfficialVersion
        _isTestVersion = true;
#else
        _isTestVersion = false;
#endif
        NSString *strBundleID = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleIdentifierKey];
        if ([strBundleID isEqualToString:@"cn.com.a-b.app.supercode"] && !self.isTestVersion)//正式版
        {
            _service = [InterfaceUrlHelper official];
        }
        else
        {
            _service = [InterfaceUrlHelper test];
        }
        _fTimeOutDuration = 60.0;
        _strDefaultInterfaceVersion = @"1.0";
    }
    return self;
}

- (nonnull NSString *)baseUrl:(NSString *)strFunction
{
    return [self.service.strBaseUrl stringByAppendingFormat:@"?function=%@", strFunction];
}

- (nonnull NSString *)argiBaseUrl:(NSString *)strFunction
{
    return [self.service.strBaseArgiUrl stringByAppendingFormat:@"?function=%@", strFunction];
}

#pragma mark handle result

+ (NSInteger)getCodeFromResult:(NSDictionary *)dicData
{
    if (![dicData isKindOfClass:[NSDictionary class]] || [dicData count] <= 0)
    {
        return -1;
    }
    NSNumber *num = [dicData objectForKey:g_strResultCodeKey];
    if ([num isKindOfClass:[NSNumber class]])
    {
        return num.integerValue;
    }
    else if ([num isKindOfClass:[NSString class]])
    {
        return num.integerValue;
    }
    return -1;
}

+ (NSString *)getMsgFromResult:(nonnull NSDictionary *)dicData
{
    if (![dicData isKindOfClass:[NSDictionary class]] || [dicData count] <= 0)
    {
        return @"";
    }
    NSString *str = [dicData objectForKey:g_strResultMessageKey];
    if ([str isKindOfClass:[NSString class]])
    {
        return str;
    }
    return @"";
}

+ (NSDictionary *)getDataFromResult:(nonnull NSDictionary *)dicData
{
    if (![dicData isKindOfClass:[NSDictionary class]] || [dicData count] <= 0)
    {
        return nil;
    }
    NSDictionary *dicResult = [dicData objectForKey:g_strResultDataKey];
    if (![dicResult isKindOfClass:[NSDictionary class]] && ![dicResult isKindOfClass:[NSArray class]])
    {
        return nil;
    }
    else if ([dicData count] <= 0)
    {
        return nil;
    }
    return dicResult;
}

#pragma mark - NSURLConnection

- (void)dataTaskWithParam:(NSDictionary *)dicParam url:(NSString *)strUrl handler:(BlockBoolStrObject)completionHandler NS_AVAILABLE_IOS(8.0)
{
    NSMutableDictionary *mtDic = [NSMutableDictionary dictionaryWithDictionary:dicParam];
    addLoginToken(mtDic);
    addClientFlag(mtDic);
    addInterfaceVersion(mtDic);
    
    NSMutableString *mtStrUrl = [[NSMutableString alloc] initWithString:strUrl];
    if ([mtStrUrl containsString:@"?"])
    {
        [mtStrUrl appendString:@"&"];
    }
    else
    {
        [mtStrUrl appendString:@"?"];
    }
    NSArray *arrayKey = [mtDic allKeys];
    for (NSString *strKey in arrayKey)
    {
        [mtStrUrl appendString:strKey];
        [mtStrUrl appendString:@"="];
        [mtStrUrl appendString:[NSString stringWithFormat:@"%@", [mtDic objectForKey:strKey]]];
        [mtStrUrl appendString:@"&"];
    }
    [mtStrUrl deleteCharactersInRange:NSMakeRange(mtStrUrl.length - 1, 1)];
    NSString *temp = [mtStrUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *nsUrl = [NSURL URLWithString:temp];
    DLog(@"%@", nsUrl);
    WeakObject(self);
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:nsUrl completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {[weakObject handleResult:completionHandler error:error responseObject:data];}];
    [dataTask resume];
    _taskCurrent = dataTask;
}

- (void)dataTaskByGet:(NSDictionary *)dicParam url:(NSString *)strUrl handler:(BlockBoolStrObject)completionHandler NS_AVAILABLE_IOS(8.0)
{
    NSMutableDictionary *mtDic = [NSMutableDictionary dictionaryWithDictionary:dicParam];
    addLoginToken(mtDic);
    addClientFlag(mtDic);
    addInterfaceVersion(mtDic);
    
    NSMutableString *mtStrUrl = [[NSMutableString alloc] initWithString:strUrl];
    if ([mtStrUrl containsString:@"?"])
    {
        [mtStrUrl appendString:@"&"];
    }
    else
    {
        [mtStrUrl appendString:@"?"];
    }
    NSArray *arrayKey = [mtDic allKeys];
    for (NSString *strKey in arrayKey)
    {
        [mtStrUrl appendString:strKey];
        [mtStrUrl appendString:@"="];
        [mtStrUrl appendString:[NSString stringWithFormat:@"%@", [mtDic objectForKey:strKey]]];
        [mtStrUrl appendString:@"&"];
    }
    [mtStrUrl deleteCharactersInRange:NSMakeRange(mtStrUrl.length - 1, 1)];
    NSString *temp = [mtStrUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *nsUrl = [NSURL URLWithString:temp];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:nsUrl];
    [request setHTTPMethod:@"GET"];
    
    NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithDictionary:[request allHTTPHeaderFields]];
    [headers setValue:@"application/json" forKey:@"Content-Type"];
    [request setAllHTTPHeaderFields:headers];
    DLog(@"%@", nsUrl);
    
    WeakObject(self);
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {[weakObject handleResult:completionHandler error:error responseObject:data];}];
    [dataTask resume];
    _taskCurrent = dataTask;
}

//- (void)dataTaskByPost:(NSDictionary *)dicParam url:(NSString *)strUrl handler:(BlockBoolStrObject)completionHandler NS_AVAILABLE_IOS(8.0)
//{
////    return [self dataTaskByGet:dicParam url:strUrl handler:completionHandler];
//    NSMutableDictionary *mtDic = [NSMutableDictionary dictionaryWithDictionary:dicParam];
//    addLoginToken(mtDic);
//    addClientFlag(mtDic);
//    addInterfaceVersion(mtDic);
//
//    NSString *temp = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURL *nsUrl = [NSURL URLWithString:temp];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:nsUrl];
//    [request setHTTPMethod:@"POST"];
//
//    NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithDictionary:[request allHTTPHeaderFields]];
//    [headers setValue:@"application/json" forKey:@"Content-Type"];
//    [request setAllHTTPHeaderFields:headers];
//
//    //设置要发送的正文内容（适用于Post请求）
//    NSMutableString *mtStrParam = [[NSMutableString alloc] init];
//    NSArray *arrayKey = [mtDic allKeys];
//    for (NSString *strKey in arrayKey)
//    {
//        [mtStrParam appendString:strKey];
//        [mtStrParam appendString:@"="];
//        [mtStrParam appendString:[mtDic objectForKey:strKey]];
//        [mtStrParam appendString:@"&"];
//    }
//    if (mtStrParam.length > 0)
//    {
//        [mtStrParam deleteCharactersInRange:NSMakeRange(mtStrParam.length - 1, 1)];
//
//        NSString *strParam = [mtDic JSONString];
//        NSData *data = [strParam dataUsingEncoding:NSUTF8StringEncoding];
//        [request setHTTPBody:data];
//    }
//    DLog(@"%@&%@", strUrl, mtStrParam);
//
//    WeakObject(self);
//    NSURLSession *session = [NSURLSession sharedSession];
//    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {[weakObject handleResult:completionHandler error:error responseObject:data];}];
//    [dataTask resume];
//    _taskCurrent = dataTask;
//}

- (void)dataTaskByPost:(NSDictionary *)dicParam url:(NSString *)strUrl handler:(BlockBoolStrObject)completionHandler NS_AVAILABLE_IOS(8.0)
{
//    return [self dataTaskByGet:dicParam url:strUrl handler:completionHandler];
    NSMutableDictionary *mtDic = [NSMutableDictionary dictionaryWithDictionary:dicParam];
    addLoginToken(mtDic);
    addClientFlag(mtDic);
    addInterfaceVersion(mtDic);
        
#ifdef DEBUG
    if (dicParam.count < 50)
    {
        NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:strUrl parameters:mtDic error:nil];
        DLog(@"%@", request);
    }
#endif
    
    AFURLSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    NSURLRequest *request = [requestSerializer requestWithMethod:@"POST" URLString:strUrl parameters:mtDic error:nil];
    
    WeakObject(self);
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request
                                                completionHandler:^(NSURLResponse *response, id responseObject, NSError *error)
                                      {
                                          [weakObject handleResult:completionHandler error:error responseObject:responseObject];
                                      }];
    [dataTask resume];
    _taskCurrent = dataTask;
}

- (void)dataTaskUpload:(NSDictionary *)dicParam imageDatas:(NSArray<NSDictionary *> *)arrayDatas url:(NSString *)strUrl progress:(BlockObject)blockUploadProgress handler:(BlockBoolStrObject)completionHandler NS_AVAILABLE_IOS(8.0)
{
    NSMutableDictionary *mtDic = [NSMutableDictionary dictionaryWithDictionary:dicParam];
    addLoginToken(mtDic);
    addClientFlag(mtDic);
    addInterfaceVersion(mtDic);
    
    AFURLSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    requestSerializer.timeoutInterval = 600;
    NSMutableURLRequest *request = [requestSerializer multipartFormRequestWithMethod:@"POST" URLString:strUrl parameters:mtDic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (NSDictionary *dicData in arrayDatas)
        {
            NSData *data = [dicData safeObjectForKey:@"imageData"];
            NSString *strDataKey = [dicData stringValueForKey:@"imageKey"];
            [formData appendPartWithFileData:data name:strDataKey fileName:[strDataKey stringByAppendingString:@".png"] mimeType:@"image/jpeg"];
        }
    } error:nil];
    NSURLSessionDataTask *dataTask = [manager uploadTaskWithStreamedRequest:request progress:blockUploadProgress completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {[self handleResult:completionHandler error:error responseObject:responseObject];
    }];
    [dataTask resume];
    _taskCurrent = dataTask;
}

- (void)handleResult:(BlockBoolStrObject)completionHandler error:(NSError *)error responseObject:(NSData *)responseObject NS_AVAILABLE_IOS(8.0)
{
    DLog(@"request finished");
    _taskCurrent = nil;
    if (completionHandler)
    {
        BlockVoid handler = ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            if (error)
            {
                if (error.code == NSURLErrorCancelled)
                {
                    completionHandler(NO, NSLocalizedString(@"requestCanceled", nil), error);
                }
                else if (error.code == NSURLErrorTimedOut)
                {
                    completionHandler(NO, NSLocalizedString(@"loadTimeout", nil), error);
                }
                else if (error.code == NSURLErrorNotConnectedToInternet)
                {
                    completionHandler(NO, NSLocalizedString(@"noNetwork", nil), error);
                }
                else if (error.code == NSURLErrorNetworkConnectionLost)
                {
                    completionHandler(NO, NSLocalizedString(@"networkDisconnect", nil), error);
                }
                else
                {
                    completionHandler(NO, error.localizedDescription, error);
                }
            }
            else
            {
                if (responseObject == nil || responseObject.length == 0)
                {
                    completionHandler(NO, NSLocalizedString(@"notJSONData", nil), nil);
                }
                else
                {
                    NSDictionary *dicData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                    NSInteger nCode = [DataProvider getCodeFromResult:dicData];
                    switch (nCode)
                    {
                        case 200:
                        case 1:
                        {
                            NSDictionary *data = [DataProvider getDataFromResult:dicData];
                            NSArray *error = [data safeObjectForKey:@"ErrorMsg"];
                            if ([error isKindOfClass:[NSArray class]] && error.count > 0)
                            {
                                completionHandler(NO, [error description], data);
                            }
                            else
                            {
                                completionHandler(YES, nil, data);
                            }
                        }
                            break;
                        case 500:
                        {
                            NSString *strMsg = [DataProvider getMsgFromResult:dicData];
                            if ([strMsg containsString:@"密码错误"])
                            {
                                completionHandler(NO, strMsg, dicData);
                                [[NSNotificationCenter defaultCenter] postNotificationName:kMSG_RELOGIN object:nil];
                            }
                            else
                            {
                                completionHandler(NO, strMsg, dicData);
                            }
                        }
                            break;
                        case 400:
                            completionHandler(NO, @"请求格式错误", dicData);
                            break;
                        case 401:
                        {
                            NSString *strMsg = [DataProvider getMsgFromResult:dicData];
                            if (strMsg.length == 0)
                                strMsg = @"用户名或密码错误";
                            completionHandler(NO, strMsg, dicData);
                            [[NSNotificationCenter defaultCenter] postNotificationName:kMSG_RELOGIN object:nil];
                        }
                            break;
                        default:
                        {
                            NSString *strMsg = [DataProvider getMsgFromResult:dicData];
                            if (strMsg.length == 0)
                            {
                                strMsg = [NSString stringWithFormat:@"%@", dicData];
                            }
                            completionHandler(NO, strMsg, dicData);
                        }
                            break;
                    }
                }
            }
        };
        dispatch_async(dispatch_get_main_queue(), handler);
    }
}

@end

#pragma mark -

void addPageParam(NSMutableDictionary *mtDic, NSInteger nCurPage)
{
    [mtDic setObject:[NSString stringWithFormat:@"%ld", (long)nCurPage] forKey:@"pageNum"];
    [mtDic setObject:[NSString stringWithFormat:@"%ld", (long)NumPerPage] forKey:@"pageSize"];
}
void addPageParamUpper(NSMutableDictionary *mtDic, NSInteger nCurPage)
{
    [mtDic setObject:[NSString stringWithFormat:@"%ld", (long)nCurPage] forKey:@"PageNumber"];
    [mtDic setObject:[NSString stringWithFormat:@"%ld", (long)NumPerPage] forKey:@"PageSize"];
}

void addLoactionParam(NSMutableDictionary *mtDic)
{
    //    CLLocationCoordinate2D location = [UserEntity shareInstance].location.coordinate;
    //    [mtDic setObject:[NSString stringWithFormat:@"%lf", location.longitude] forKey:@"longitude"];
    //    [mtDic setObject:[NSString stringWithFormat:@"%lf", location.latitude] forKey:@"latitude"];
}

void addLoginToken(NSMutableDictionary *mtDic)
{
    if ([UserEntity shareInstance].strToken.length > 0)
        [mtDic setObject:[UserEntity shareInstance].strToken forKey:@"token"];
}

void addUserName(NSMutableDictionary *mtDic)
{
    if ([UserEntity shareInstance].strName.length > 0)
        [mtDic setObject:[UserEntity shareInstance].strName forKey:@"UserName"];
}

void addUserID(NSMutableDictionary *mtDic)
{
    if ([UserEntity shareInstance].strID.length > 0)
        [mtDic setObject:[UserEntity shareInstance].strID forKey:@"userId"];
}

void addClientFlag(NSMutableDictionary *mtDic)
{
    NSString *strVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    [mtDic setObject:[NSString stringWithFormat:@"iPhone,%@", strVersion] forKey:@"Client"];
}

void addInterfaceVersion(NSMutableDictionary *mtDic)
{
    NSArray *arrayKeys = [mtDic allKeys];
    if ([arrayKeys containsObject:@"version"])
    {
        
    }
    else
    {
        [mtDic setObject:[DataProvider shareInstance].strDefaultInterfaceVersion forKey:@"version"];
    }
}
