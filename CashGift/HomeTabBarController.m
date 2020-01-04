//
//  ViewController.m
//  CashGift
//
//  Created by EadkennyChan on 17/2/9.
//  Copyright © 2017年 ZX. All rights reserved.
//

#import "HomeTabBarController.h"
#import "BanquetRecordVC.h"
#import "SettingVC.h"
#import "EditBanquetVC.h"

@interface HomeTabBarController ()<UITabBarControllerDelegate>

@end

@implementation HomeTabBarController

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  
  self.delegate = self;
  self.tabBar.tintColor = RGBCOLOR(216, 30, 6);
  [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:RGBCOLOR(170, 170, 170), NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
  [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:RGBCOLOR(216, 30, 6), NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
  
//    [UITabBar appearance].shadowImage = [UIImage new];
  [self.tabBar setBackgroundImage:[[UIImage alloc] init]];
  
//  [self loadLatestBanquet];
  [self addBanquetRecordList];
  [self addSetting];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadLatestBanquet
{
  EditBanquetVC *vc = [[EditBanquetVC alloc] init];
  UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
//  nav.title = banquet.strName;
//  vc.banquet = banquet;
  nav.tabBarItem.image = [UIImage imageNamed:@"laiwang"];
  [self addChildViewController:nav];
}

- (void)addBanquetRecordList
{
  BanquetRecordVC *vc = [[BanquetRecordVC alloc] init];
  UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
  nav.title = @"宴席";
  nav.tabBarItem.image = [UIImage imageNamed:@"yanxi"];
  [self addChildViewController:nav];
}

- (void)addSetting
{
  SettingVC *vc = [[SettingVC alloc] init];
  UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
  nav.title = @"设置";
  nav.tabBarItem.image = [UIImage imageNamed:@"setting"];
  [self addChildViewController:nav];
}

@end
