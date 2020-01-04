//
//  AppDelegate.m
//  CashGift
//
//  Created by EadkennyChan on 17/2/9.
//  Copyright © 2017年 ZX. All rights reserved.
//

#import "AppDelegate.h"
#import <Bugly/Bugly.h>
//#import "BaiduMobStat.h"
#import "WXApi.h"
#import "HomeTabBarController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  [self setupTencent];
  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  self.window.backgroundColor = [UIColor whiteColor];
  [self.window makeKeyAndVisible];
  
  HomeTabBarController *vc = [[HomeTabBarController alloc] init];
  self.window.rootViewController = vc;
  
  // Override point for customization after application launch.
  return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - 百度统计
    
//- (void)initBaidu {
//  BaiduMobStat *statTracker = [BaiduMobStat defaultStat];
//  statTracker.shortAppVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//  [statTracker startWithAppId:@"b3a2fb31a8"];
//}
#pragma mark - Bugly

- (void)setupTencent {
  //向微信注册
//  [WXApi registerApp:@"wx55a9fde69fdb1b69"];
  [WXApi registerApp:@"wx8d5a6b81493d0fbf"];  // OBD的微信
//  [Bugly startWithAppId:@"0594122ab2"];
}

@end
