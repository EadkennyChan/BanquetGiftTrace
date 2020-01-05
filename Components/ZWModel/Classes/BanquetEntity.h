//
//  BanquetEntity.h
//  CashGift
//
//  Created by EadkennyChan on 17/2/15.
//  Copyright © 2017年 ZX. All rights reserved.
//

#import "BaseEntity.h"
#import "ParticipantEntity.h"

/**
 *  宴会酒席 对象
 */
@interface BanquetEntity : BaseEntity

@property (nonatomic, copy)NSString *strName;
@property (nonatomic, retain)NSString *date;
@property (nonatomic, retain)NSString *dateCreate;
@property (nonatomic, copy)NSString *strTbName;
@property (nonatomic, retain, readonly)NSArray<ParticipantEntity *> *arrParticipant;
- (void)addParticipant:(ParticipantEntity *)participant;

+ (instancetype)banquetWithDBPath:(NSString *)strPath fileName:(NSString *)strFileName;
- (void)saveBanquetToDBFilePath:(NSString *)strPath;

@end
