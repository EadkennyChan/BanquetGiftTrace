//
//  DataSetVC.h
//  CashGift
//
//  Created by EadkennyChan on 17/2/16.
//  Copyright © 2017年 ZX. All rights reserved.
//

#import "BaseVC.h"

@protocol DataSettingChangedDelegate;

@interface DataSetVC : BaseVC

@property (nullable, nonatomic, retain)NSMutableArray *mtArrayData;
@property (nullable, nonatomic, weak)id<DataSettingChangedDelegate> delegate;

@end

@protocol DataSettingChangedDelegate <NSObject>

- (void)dataSettingDidChanged:(nullable NSArray *)arrayData;

@end
