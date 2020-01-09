//
//  BanquetEntity.m
//  CashGift
//
//  Created by EadkennyChan on 17/2/15.
//  Copyright © 2017年 ZX. All rights reserved.
//

#import "BanquetEntity.h"

@interface BanquetEntity ()
{
    NSMutableArray<ParticipantEntity *> *m_mtArrayData;
}
@end

@implementation BanquetEntity

- (id)init
{
    self = [super init];
    if (self)
    {
      NSDateFormatter * fmtDate = [[NSDateFormatter alloc] init];
      fmtDate.dateFormat = @"yyyy-MM-dd";
      _strDate = [fmtDate stringFromDate:[NSDate date]];
      _strDateCreate = _strDate;
    }
    return self;
}

+ (BanquetEntity *)banquetWithName:(NSString *)strName
{
  BanquetEntity *banquet = [[BanquetEntity alloc] init];
  banquet.strName = strName;
  return banquet;
}
    
- (NSArray<ParticipantEntity *> *)getParticipants
{
  return [m_mtArrayData copy];
}
    
- (void)addParticipant:(ParticipantEntity *)participant
{
    [m_mtArrayData addObject:participant];
}

- (void)setParticipants:(nonnull NSArray<ParticipantEntity *> *)participants
{
  m_mtArrayData = [NSMutableArray arrayWithArray:participants];
}
@end
