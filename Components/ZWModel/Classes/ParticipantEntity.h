//
//  ParticipantEntity.h
//  CashGift
//
//  Created by EadkennyChan on 17/2/15.
//  Copyright © 2017年 ZX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

/**
 *  宴会来往登记贺礼信息
 */
@interface ParticipantEntity : NSObject

@property (nonatomic, retain)NSString *strName; //随礼人员
@property (nonatomic, assign)CGFloat fAmount; //随礼金额
@property (nonatomic, retain)NSArray<NSString *> *arrayReturn;  //回礼
@property (nonatomic, retain)NSString *strRelation; //关系

@end
