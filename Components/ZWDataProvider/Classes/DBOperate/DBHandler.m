//
//  DataProvider.m
//  ZWNetRequestKit
//
//  Created by 陈正旺 on 14/12/27.
//  Copyright (c) 2014年 zwchen. All rights reserved.
//

#import "DBHandler.h"
#import "FMDB/FMDatabase.h"
#import "ParticipantEntity.h"

@interface DBHandler()

@property (nonatomic, retain) FMDatabase *db;

@end

@implementation DBHandler

+ (instancetype)shareInstance
{
  static dispatch_once_t once;
  static DBHandler *sharedRequest;
  dispatch_once(&once, ^{sharedRequest = [[self alloc] init];});
  return sharedRequest;
}

+ (void)loadBanquetList
{
  FMDatabase *db = [FMDatabase databaseWithPath:strFile];
  if (![db open])
  {
    db = nil;
    return;
  }
  [self shareInstance].db = db;
  
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

@end
