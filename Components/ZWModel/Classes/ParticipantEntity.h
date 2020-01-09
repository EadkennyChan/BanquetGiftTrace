//
//  ParticipantEntity.h
//  CashGift
//
//  Created by EadkennyChan on 17/2/15.
//  Copyright © 2017年 ZX. All rights reserved.
//

#import "BaseEntity.h"
#import <CoreGraphics/CoreGraphics.h>

/**
 *  宴会来往登记贺礼信息
 */
@interface ParticipantEntity : BaseEntity

@property (nonatomic, retain, nonnull)NSString *strName; //随礼人员
@property (nonatomic, assign)CGFloat fAmount; //随礼金额
@property (nonatomic, retain, nullable)NSArray<NSString *> *arrayReturn;  //回礼
@property (nonatomic, retain, nullable)NSString *strRelation; //关系
@property (nonatomic, retain, nonnull)NSString *strDate;
@property (nonatomic, retain, nonnull)NSString *strDateCreate;

@end
