//
//  BaseEntity.h
//  Pods
//
//  Created by EadkennyChan on 17/6/27.
//
//

#import <Foundation/Foundation.h>

/**
 *  基类模型
 *  只包含一个ID字段
 */
@interface BaseEntity : NSObject<NSCopying, NSCoding>

@property (nonatomic, copy)NSString *strID;//ID

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
