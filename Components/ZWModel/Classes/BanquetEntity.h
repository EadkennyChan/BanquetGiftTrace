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

@property (nonatomic, copy, nonnull)NSString * strName;
@property (nonatomic, retain, nonnull)NSString *strDate;
@property (nonatomic, retain, nonnull)NSString *strDateCreate;
@property (nonatomic, copy, nonnull)NSString *strTbName;

+ (BanquetEntity *)banquetWithName:(NSString *)strName;

- (nullable NSArray<ParticipantEntity *> *)getParticipants;
- (void)addParticipant:(nonnull ParticipantEntity *)participant;
- (void)setParticipants:(nonnull NSArray<ParticipantEntity *> *)participants;

@end
