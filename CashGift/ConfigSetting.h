//
//  ConfigSetting.h
//  CashGift
//
//  Created by EadkennyChan on 17/2/17.
//  Copyright © 2017年 ZX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConfigSetting : NSObject

+ (NSString *)dataDirectoryPath;

+ (NSMutableArray *)loadReturnGift;
+ (void)saveReturnGiftDataToFile:(NSMutableArray *)arrReturn;
+ (NSMutableArray *)loadRelation;
+ (void)saveRelationDataToFile:(NSMutableArray *)arrRelation;

@end
