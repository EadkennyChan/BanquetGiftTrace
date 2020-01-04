//
//  ConfigSetting.m
//  CashGift
//
//  Created by EadkennyChan on 17/2/17.
//  Copyright © 2017年 ZX. All rights reserved.
//

#import "ConfigSetting.h"

@implementation ConfigSetting

+ (NSString *)dataDirectoryPath
{
    NSString *strPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    strPath = [strPath stringByAppendingPathComponent:@"data"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL bRet = YES;
    BOOL bIsDirectory = YES; //如果目录不存在则创建
    if (![fileManager fileExistsAtPath:strPath isDirectory:&bIsDirectory])
    {
        if (![fileManager createDirectoryAtPath:strPath withIntermediateDirectories:NO attributes:nil error:nil])
        {
            DLog(@"create directory %@ error!", strPath);
            bRet = NO;
        }
    }
    return strPath;
}

+ (NSMutableArray *)loadReturnGift
{
    NSString *strPath = [[ConfigSetting dataDirectoryPath] stringByAppendingPathComponent:@"returnGift.plist"];
    NSMutableArray *mtArrayReturn = [NSMutableArray arrayWithContentsOfFile:strPath];
    if (mtArrayReturn == nil)
        mtArrayReturn = [NSMutableArray arrayWithCapacity:1];
    return mtArrayReturn;
}

+ (void)saveReturnGiftDataToFile:(NSMutableArray *)arrReturn
{
    NSString *strPath = [[ConfigSetting dataDirectoryPath] stringByAppendingPathComponent:@"returnGift.plist"];
    [arrReturn writeToFile:strPath atomically:NO];
}

+ (NSMutableArray *)loadRelation
{
    NSString *strPath = [[ConfigSetting dataDirectoryPath] stringByAppendingPathComponent:@"relation.plist"];
    NSMutableArray *mtArrayRelation = [NSMutableArray arrayWithContentsOfFile:strPath];
    if (mtArrayRelation == nil)
    {
        mtArrayRelation = [NSMutableArray arrayWithObjects:@"亲戚", nil];
        [mtArrayRelation writeToFile:strPath atomically:NO];
    }
    return mtArrayRelation;
}

+ (void)saveRelationDataToFile:(NSMutableArray *)arrRelation
{
    NSString *strPath = [[ConfigSetting dataDirectoryPath] stringByAppendingPathComponent:@"relation.plist"];
    [arrRelation writeToFile:strPath atomically:NO];
}

@end
