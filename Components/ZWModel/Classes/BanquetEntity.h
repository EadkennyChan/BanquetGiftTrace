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
@property (nonatomic, retain)NSString *strDate;
@property (nonatomic, retain)NSString *strDateCreate;
@property (nonatomic, copy)NSString *strTbName;
- (nullable NSArray<ParticipantEntity *> *)getParticipants;
- (void)addParticipant:(ParticipantEntity *)participant;

@end
