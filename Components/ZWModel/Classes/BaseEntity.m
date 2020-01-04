//
//  BaseEntity.m
//  Pods
//
//  Created by EadkennyChan on 17/6/27.
//
//

#import "BaseEntity.h"
#import <objc/runtime.h>

@implementation BaseEntity

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [self init];
    if (self)
    {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setId:(NSString *)strID
{
    _strID = strID;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    DLog(@"%@, key=%@", NSStringFromSelector(_cmd), key);
}

- (BOOL)isEqual:(BaseEntity *)entity
{
    if (entity == nil)
    {
        return NO;
    }
    else if (![[self class] isEqual:[entity class]])
    {
        return NO;
    }
    unsigned int count;
    Class cls = [self class];
    id value = nil;
    id valueCompared = nil;
    while (cls != [NSObject class] && cls != nil)
    {
        Ivar* ivars = class_copyIvarList(cls, &count);
        for (int i = 0; i < count; i++)
        {
            Ivar ivar = ivars[i];
            const char *name = ivar_getName(ivar);
            NSString *strName = [NSString stringWithUTF8String:name];
            value = [self valueForKey:strName];
            valueCompared = [entity valueForKey:strName];
            if (value == nil && valueCompared == nil)
            {
            }
            else if (value == nil || valueCompared == nil)
            {
                return NO;
            }
            else if ([value isKindOfClass:[NSString class]])
            {
                if (![value isEqualToString:(NSString *)valueCompared])
                {
                    return NO;
                }
            }
            else if ([value isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dicValue = (NSDictionary *)value;
                NSDictionary *dicValueCompared = (NSDictionary *)valueCompared;
                if (dicValue.count != dicValueCompared.count)
                {
                    return NO;
                }
                NSArray *arrayKeys = [dicValue allKeys];
                for (NSString *strKey in arrayKeys)
                {
                    value = [dicValue objectForKey:strKey];
                    valueCompared = [dicValueCompared objectForKey:strKey];
                }
            }
            else if ([value isKindOfClass:[NSArray class]])
            {
                NSArray *arrayValues = (NSArray *)value;
                NSArray *arrayValuesCompared = (NSArray *)valueCompared;
                if (arrayValues.count != arrayValuesCompared.count)
                {
                    return NO;
                }
                NSInteger nCount = arrayValues.count;
                for (NSInteger n = 0; n < nCount; n++)
                {
                    value = [arrayValues objectAtIndex:n];
                    valueCompared = [arrayValues objectAtIndex:n];
                    if (![value isEqual:valueCompared])
                    {
                        return NO;
                    }
                }
            }
            else
            {
                if (![value isEqual:valueCompared])
                {
                    return NO;
                }
            }
        }
        free(ivars);
        cls = class_getSuperclass(cls);
    }
    return YES;
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(nullable NSZone *)zone
{
    BaseEntity *objDump = [[self class] allocWithZone:zone];
    
    unsigned int count;
    Class cls = [self class];
    while (cls != [NSObject class] && cls != nil)
    {
        Ivar* ivars = class_copyIvarList(cls, &count);
        for (int i = 0; i < count; i++)
        {
            Ivar ivar = ivars[i];
            const char *name = ivar_getName(ivar);
            NSString *strName = [NSString stringWithUTF8String:name];
            id value = [self valueForKey:strName];
            if (value == nil)
            {
            }
            else if ([NSStringFromClass([value class]) rangeOfString:@"NSMutable"].location != NSNotFound)
            {
                [objDump setValue:[value mutableCopy] forKey:strName];
            }
            else if ([value isKindOfClass:[NSValue class]] || [value isKindOfClass:[NSNumber class]])
            {
                [objDump setValue:value forKey:strName];
            }
            else
            {
                [objDump setValue:[value copy] forKey:strName];
            }
        }
        free(ivars);
        cls = class_getSuperclass(cls);
    }
    return objDump;
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    unsigned int count;
    Ivar* ivars = class_copyIvarList([self class], &count);
    for (int i = 0; i < count; i++)
    {
        Ivar ivar = ivars[i];
        const char* name = ivar_getName(ivar);
        NSString* strName = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:strName];
        if ([value respondsToSelector:@selector(encodeWithCoder:)])
        {
            [aCoder encodeObject:value forKey:strName];
        }
    }
    free(ivars);
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    if (self)
    {
        unsigned int count;
        Ivar *ivars = class_copyIvarList([self class], &count);
        
        for (int i = 0; i < count; i ++)
        {
            Ivar ivar = ivars[i];
            const char *name = ivar_getName(ivar);
            NSString *strName = [NSString stringWithUTF8String:name];
            id value = [aDecoder decodeObjectForKey:strName];
            [self setValue:value forKey:strName];
        }
        free(ivars);
    }
    return self;
}

@end
