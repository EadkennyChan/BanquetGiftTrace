//
//  SettingVC.m
//  CashGift
//
//  Created by EadkennyChan on 17/2/10.
//  Copyright © 2017年 ZX. All rights reserved.
//

#import "SettingVC.h"
#import "DataDefineVC.h"
#import <ZWUtilityKit/ZWTableViewCell.h>
#import "TableShowSettingVC.h"

@interface SettingVC ()<UITableViewDelegate, UITableViewDataSource> {
  NSString *m_strCellID;
  UITableView *m_tableView;
  
  NSArray<NSArray *> *m_arrTitles;
}
@end

@implementation SettingVC

- (void)viewDidLoad
{
  [super viewDidLoad];
  !self.title && self.navigationController.title && (self.title = self.navigationController.title);
  // Do any additional setup after loading the view.
  [self createTableView];
  
  m_arrTitles = @[@[@"数据字典", @"表单显示设置"], @[@"版本"]];
}
    
- (void)createTableView
{
    m_strCellID = @"SettingCellID";
    
    UITableView *tableV = [[UITableView alloc] initWithFrame:self.view.bounds];
    tableV.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tableV.backgroundColor = [UIColor clearColor];
    tableV.delegate = self;
    tableV.dataSource = self;
    tableV.tableFooterView = [UIView new];
    [self.view addSubview:m_tableView = tableV];
    [tableV registerClass:[ZWLabelLabelCell class] forCellReuseIdentifier:ZWLabelLabelCellID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return m_arrTitles.count;
}
    
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_arrTitles[section].count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  return [UIView new];
}
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  ZWLabelLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:ZWLabelLabelCellID];
  cell.labelTip.text = m_arrTitles[indexPath.section][indexPath.row];
  switch (indexPath.section) {
    case 0:
    {
      [cell showAccessory:YES image:@"iconArrow-right"];
      cell.labelContent.text = nil;
    }
      break;
    case 1:
    {
      cell.labelContent.textAlignment = NSTextAlignmentRight;
      cell.labelContent.font = [UIFont systemFontOfSize:14];
      cell.labelContent.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
      cell.labelContent.textAlignment = NSTextAlignmentRight;
      [cell showAccessory:NO image:nil];
    }
      break;
    default:
      break;
  }
  if (indexPath.row + 1 == m_arrTitles[indexPath.section].count) {
    [cell hiddenBottomLine];
  } else {
    [cell showBottomSeparatorLine:YES color:nil];
  }
  return cell;
}
    
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  UIViewController *vcRet;
  if (indexPath.section == 0) {
    if (indexPath.row == 0) {
      DataDefineVC *vc = [[DataDefineVC alloc] init];
      vcRet = vc;
    } else if (indexPath.row == 1) {
      TableShowSettingVC *vc = [[TableShowSettingVC alloc] init];
      vcRet = vc;
    }
  }
  if (vcRet) {
    vcRet.hidesBottomBarWhenPushed = YES;
    vcRet.title = m_arrTitles[indexPath.section][indexPath.row];
    [self.navigationController pushViewController:vcRet animated:YES];
  }
}

@end
