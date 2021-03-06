//
//  DataProvider.m
//  ZWNetRequestKit
//
//  Created by 陈正旺 on 14/12/27.
//  Copyright (c) 2014年 zwchen. All rights reserved.
//

#import "DBHandler.h"
#import "FMDB/FMDatabase.h"
#import "ConfigSetting.h"

@interface DBHandler()

@property (nonatomic, retain, readonly) FMDatabase *db;

@end

@implementation DBHandler

+ (instancetype)shareInstance
{
  static dispatch_once_t once;
  static DBHandler *sharedRequest;
  dispatch_once(&once, ^{sharedRequest = [[self alloc] init];});
  return sharedRequest;
}

- (instancetype)init
{
  if (self = [super init])
  {
    [self initBanquetDB];
  }
  return self;
}

- (void)dealloc
{
  [self.db close];
}
/**
 *  初始化宴席数据库文件
 */
- (void)initBanquetDB
{
  NSString *strBasePath = [ConfigSetting dataDirectoryPath];
  NSString *strDBFile = [strBasePath stringByAppendingFormat:@"banquet.db"];
  FMDatabase *db = [FMDatabase databaseWithPath:strDBFile];
  if (![db open])
  {
    db = nil;
    return;
  }
  // 宴会名称、更新日期、创建日期、表名
  if (![db executeUpdate:@"create table if not exists banquet (id integer primary key AUTOINCREMENT, name text, updateDate text, createDate text, tbName text)"])
  {//建表失败
    NSLog(@"表创建失败了");
  }
  _db = db;
}

+ (BOOL)addBanquet:(BanquetEntity *)banquet
{
  FMDatabase *db = [(DBHandler *)[self shareInstance] db];
  if (!db)
  {
    return NO;
  }
  banquet.strTbName = [NSString stringWithFormat:@"_%ld", (long)[NSDate timeIntervalSinceReferenceDate]];
  // 判断表是否存在
  NSString *existsSql = [NSString stringWithFormat:@"select count(name) as countNum from banquet where type = 'table' and name = '%@'", banquet.strTbName];
  FMResultSet *rs = [db executeQuery:existsSql];
  if ([rs next])
  {
    NSInteger count = [rs intForColumn:@"countNum"];
    if (count == 1) // 如果存在
    {
      banquet.strTbName = [banquet.strTbName stringByAppendingFormat:@"%d", arc4random() / 10];
    }
  }
  
  BOOL bRet = [db executeUpdate:@"insert into banquet (name, updateDate, createDate, tbName) values (?, ?, ?, ?)" ,banquet.strName, banquet.strDate, banquet.strDateCreate, banquet.strTbName];
  [db commit];
  if (bRet)
  {
    // 礼品登记人、金额、回礼、关系、更新日期、创建日期
    NSString *strSql = [NSString stringWithFormat:@"create table if not exists %@ (id integer primary key AUTOINCREMENT, name text, amount text, feedback text, relation text, updateDate text, createDate text)", banquet.strTbName];
    if (![db executeUpdate:strSql])
    { //建表失败
      return NO;
    }
  }
  return bRet;
}

/**
 *  加载 宴席 列表
 */
+ (NSArray<BanquetEntity *> *)loadBanquetList
{
  FMDatabase *db = [(DBHandler *)[self shareInstance] db];
  if (!db)
  {
    return nil;
  }
  NSMutableArray *array = [NSMutableArray array];
  BanquetEntity *banquet;
  FMResultSet *rs = [db executeQuery:@"select * from banquet"];
  while ([rs next])
  {
    banquet = [[BanquetEntity alloc] init];
    banquet.strID = [rs stringForColumn:@"id"];
    banquet.strName = [rs stringForColumn:@"name"];
    banquet.strDate = [rs stringForColumn:@"updateDate"];
    banquet.strDateCreate = [rs stringForColumn:@"createDate"];
    banquet.strTbName = [rs stringForColumn:@"tbName"];
    [array addObject:banquet];
  }
  return array;
}

+ (BOOL)updateBanquet:(BanquetEntity *)banquet
{
  FMDatabase *db = [(DBHandler *)[self shareInstance] db];
  if (!db)
  {
    return NO;
  }
  
  BOOL bRet = [db executeUpdate:@"update banquet set name='%@', updateDate='%@', where id='%@'", banquet.strName, banquet.strDate, banquet.strID];
  [db commit];
  return bRet;
}

+ (BOOL)deleteBanquet:(BanquetEntity *)banquet
{
  FMDatabase *db = [(DBHandler *)[self shareInstance] db];
  if (!db)
  {
    return NO;
  }
  
  BOOL bRet = [db executeUpdate:@"delete from banquet where id='%@'", banquet.strID];
  [db commit];
  return bRet;
}

+ (nullable NSArray<ParticipantEntity *> *)loadParticipants:(nonnull BanquetEntity *)banquet
{
  FMDatabase *db = [(DBHandler *)[self shareInstance] db];
  if (!db || !banquet)
  {
    return nil;
  }
  NSString *strSql = [NSString stringWithFormat:@"select * from %@", banquet.strTbName];
  FMResultSet *rs = [db executeQuery:strSql];
  ParticipantEntity *participant;
  NSMutableArray *array = [NSMutableArray array];
  while ([rs next])
  {
    participant = [[ParticipantEntity alloc] init];
    participant.strID = [rs stringForColumn:@"id"];
    participant.strName = [rs stringForColumn:@"name"];
    participant.fAmount = [rs stringForColumn:@"amount"].floatValue;
    participant.strDate = [rs stringForColumn:@"updateDate"];
    participant.strDateCreate = [rs stringForColumn:@"createDate"];
    
    NSString *strFeedbackGift = [rs stringForColumn:@"feedback"];
    participant.arrayReturn = [strFeedbackGift componentsSeparatedByString:@"%@*!&#"];
    participant.strRelation = [rs stringForColumn:@"relation"];
    
    [array addObject:participant];
  }
  [banquet setParticipants:array];
  
  return [array copy];
}

+ (BOOL)addParticipant:(ParticipantEntity *)participant toBanquet:(BanquetEntity *)banquet
{
  FMDatabase *db = [(DBHandler *)[self shareInstance] db];
  if (!db || !banquet || !participant)
  {
    return NO;
  }
  [banquet addParticipant:participant];
  
  NSString *strReturn = @"";
  for (NSString *str in participant.arrayReturn)
  {
    strReturn = [strReturn stringByAppendingFormat:@"%@*!&#", str];
  }
  if (participant.arrayReturn.count > 0)
  {
    strReturn = [strReturn substringToIndex:strReturn.length - 4];
  }
  NSString *strSql = [NSString stringWithFormat:@"insert into %@ (name, amount, feedback, relation, updateDate, createDate) values (?, ?, ?, ?, ?, ?)", banquet.strTbName];
  BOOL bRet = [db executeUpdate:strSql ,participant.strName, [NSString stringWithFormat:@"%.2f", participant.fAmount], strReturn, participant.strRelation, participant.strDate, participant.strDateCreate];
  if (bRet)
  {
    strSql = @"";
  }
  [db commit];
  return bRet;
}
//
//+ (void)loadParticipants:(BanquetEntity *)Banquet
//{
//  FMDatabase *db = [FMDatabase databaseWithPath:strFile];
//  if (![db open])
//  {
//    db = nil;
//    return;
//  }
//  [self shareInstance].db = db;
//
//  ParticipantEntity *partici;
//  NSString *strReturn;
//  FMResultSet *rs = [db executeQuery:@"select rowid, * from banquet"];
//  while ([rs next])
//  {
//    partici = [[ParticipantEntity alloc] init];
//    partici.strName = [rs stringForColumn:@"name"];
//    partici.fAmount = [rs doubleForColumn:@"amount"];
//    strReturn = [rs stringForColumn:@"return"];
//    partici.arrayReturn = [strReturn componentsSeparatedByString:@"*!&#"];
//    partici.strRelation = [rs stringForColumn:@"relation"];
//    [m_mtArrayData addObject:partici];
//  }
//}
//
//+ (void)saveBanquetToDBFilePath:(NSString *)strPath
//{
//  NSDateFormatter *formatterDate = [NSDateFormatter new];
//  formatterDate.dateFormat = @"yyyy-MM-dd";
//  NSString *strDBFile = [strPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@~$@%@.db", _strName, [formatterDate stringFromDate:_date]]];
//  if (m_db == nil)
//  {
//    FMDatabase *db = [FMDatabase databaseWithPath:strDBFile];
//    if (![db open])
//    {
//      db = nil;
//      return;
//    }
//    if (![db executeUpdate:@"create table banquet (name text, amount double, return text, relation text)"])
//    {//建表失败
//    }
//    m_db = db;
//  }
//}

@end
