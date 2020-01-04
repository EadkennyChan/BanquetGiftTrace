//
//  BanquetEntity.h
//  CashGift
//
//  Created by EadkennyChan on 17/2/15.
//  Copyright © 2017年 ZX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParticipantEntity.h"

/**
 *  宴会酒席 对象
 */
@interface BanquetEntity : NSObject

@property (nonatomic, retain)NSString *strName;
@property (nonatomic, retain)NSDate *date;
@property (nonatomic, retain)NSDate *dateCreate;
@property (nonatomic, retain, readonly)NSArray<ParticipantEntity *> *arrParticipant;
- (void)addParticipant:(ParticipantEntity *)participant;

+ (instancetype)banquetWithDBPath:(NSString *)strPath fileName:(NSString *)strFileName;
- (void)saveBanquetToDBFilePath:(NSString *)strPath;

@end
