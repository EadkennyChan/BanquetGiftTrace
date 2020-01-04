//
//  BaseEntity.h
//  Pods
//
//  Created by EadkennyChan on 17/6/27.
//
//

#import "BaseEntity.h"

/**
 *  基类模型
 *  只包含一个ID字段
 */
@interface UserEntity : BaseEntity

@property (nonatomic, copy, readonly)NSString *strToken;

#pragma mark - method

+ (instancetype)shareInstance;

@end
