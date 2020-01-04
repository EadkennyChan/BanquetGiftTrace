//
//  DataProvider+Banquet.h
//  DataProvider
//
//  Created by Eadkenny on 2020/01/02.
//

#import "DataProvider.h"

#pragma mark - 用户模块
/*
 *  @brief:获取用户列表
 *  @param:
 *       strKeyword 搜索关键字
 *       strFieldKey 排序字段
 *       bIsAcessding 针对排序字段是否进行升序
 *       nPageIndex 页码
 *       completionHandler：请求完成调用方法
 */
void getBanquetList(NSString *_Nullable strKeyword, NSString *_Nullable strOrderField, BOOL bIsAcessding, NSInteger nPageIndex, BlockBoolStrObject _Nullable completionHandler);

#pragma mark - 产品模块
