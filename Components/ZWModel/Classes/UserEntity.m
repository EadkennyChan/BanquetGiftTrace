//
//  BaseEntity.m
//  Pods
//
//  Created by EadkennyChan on 17/6/27.
//
//

#import "UserEntity.h"

static UserEntity *g_userManager;

@implementation UserEntity

+ (instancetype)shareInstance
{
  @synchronized(self)
  {
    if (g_userManager == nil)
    {
      g_userManager = [[self alloc] init];
    }
  }
  return g_userManager;
}

@end
