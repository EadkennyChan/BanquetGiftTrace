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
        _date = [NSDate date];
        m_mtArrayData = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}
    
- (void)dealloc
{
    [m_db close];
}
    
- (NSArray *)arrParticipant
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
    
- (void)loadParticipantFromDBFile:(NSString *)strFile
{
    FMDatabase *db = [FMDatabase databaseWithPath:strFile];
    if (![db open])
    {
        db = nil;
        return;
    }
    m_db = db;
    
    ParticipantEntity *partici;
    NSString *strReturn;
    FMResultSet *rs = [db executeQuery:@"select rowid, * from banquet"];
    while ([rs next])
    {
        partici = [[ParticipantEntity alloc] init];
        partici.strName = [rs stringForColumn:@"name"];
        partici.fAmount = [rs doubleForColumn:@"amount"];
        strReturn = [rs stringForColumn:@"return"];
        partici.arrayReturn = [strReturn componentsSeparatedByString:@"*!&#"];
        partici.strRelation = [rs stringForColumn:@"relation"];
        [m_mtArrayData addObject:partici];
    }
}

- (void)saveBanquetToDBFilePath:(NSString *)strPath
{
    NSDateFormatter *formatterDate = [NSDateFormatter new];
    formatterDate.dateFormat = @"yyyy-MM-dd";
    NSString *strDBFile = [strPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@~$@%@.db", _strName, [formatterDate stringFromDate:_date]]];
    if (m_db == nil)
    {
        FMDatabase *db = [FMDatabase databaseWithPath:strDBFile];
        if (![db open])
        {
            db = nil;
            return;
        }
        if (![db executeUpdate:@"create table banquet (name text, amount double, return text, relation text)"])
        {//建表失败
        }
        m_db = db;
    }
}

@end
