//
//  BanquetEntity.m
//  CashGift
//
//  Created by EadkennyChan on 17/2/15.
//  Copyright © 2017年 ZX. All rights reserved.
//

#import "BanquetEntity.h"
#import "FMDB/FMDatabase.h"

@interface BanquetEntity ()
{
    NSMutableArray<ParticipantEntity *> *m_mtArrayData;
    FMDatabase *m_db;
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
      m_mtArrayData = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}
    
- (void)dealloc
{
    [m_db close];
}
    
- (NSArray<ParticipantEntity *> *)getParticipants
{
    return [m_mtArrayData copy];
}
    
- (void)addParticipant:(ParticipantEntity *)participant
{
    [m_mtArrayData addObject:participant];
    NSString *strReturn = @"";
    for (NSString *str in participant.arrayReturn)
    {
        strReturn = [strReturn stringByAppendingFormat:@"%@*!&#", str];
    }
    if (participant.arrayReturn.count > 0)
        strReturn = [strReturn substringToIndex:strReturn.length - 4];
    [m_db executeUpdate:@"insert into banquet (name, amount, return, relation) values (?, ?, ?, ?)" ,participant.strName, [NSNumber numberWithFloat:participant.fAmount], strReturn, participant.strRelation];
    [m_db commit];
}
@end
