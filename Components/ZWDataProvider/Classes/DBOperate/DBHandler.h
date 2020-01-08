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
#import "BanquetEntity.h"
#import "ParticipantEntity.h"

@interface DBHandler : NSObject

+ (instancetype)shareInstance;

/**
 *  加载 宴会酒席 列表
 */
+ (nullable NSArray<BanquetEntity *> *)loadBanquetList;
+ (BOOL)addBanquet:(nonnull BanquetEntity *)banquet;
+ (BOOL)updateBanquet:(nonnull BanquetEntity *)banquet;
+ (BOOL)deleteBanquet:(nonnull BanquetEntity *)banquet;

+ (nullable NSArray<ParticipantEntity *> *)loadParticipants:(nonnull BanquetEntity *)Banquet;
+ (BOOL)addParticipant:(ParticipantEntity *)participant toBanquet:(nonnull BanquetEntity *)banquet;

@end
