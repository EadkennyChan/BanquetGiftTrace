//
//  TableShowSettingVC.m
//  CashGift
//
//  Created by JGW on 2020/9/21.
//  Copyright © 2020 ZX. All rights reserved.
//

#import "TableShowSettingVC.h"
#import <ZWUtilityKit/ZWTableViewCell.h>

@interface TableShowSettingVC ()<UITableViewDelegate, UITableViewDataSource>
{
  UITableView *m_tableView;
}
@end

@implementation TableShowSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
  !self.title && self.navigationController.title && (self.title = self.navigationController.title);
  // Do any additional setup after loading the view.
  [self createTableView];
}
    
- (void)createTableView {
  UITableView *tableV = [[UITableView alloc] initWithFrame:self.view.bounds];
  tableV.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  tableV.backgroundColor = [UIColor clearColor];
  tableV.delegate = self;
  tableV.dataSource = self;
  tableV.tableFooterView = [UIView new];
  [self.view addSubview:m_tableView = tableV];
  [tableV registerClass:[ZWLabelTFCell class] forCellReuseIdentifier:ZWLabelTFCellID];
  [tableV registerClass:[ZWLabelLabelCell class] forCellReuseIdentifier:ZWLabelLabelCellID];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == 0) {
    ZWLabelLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:ZWLabelLabelCellID];
    cell.labelTip.text = @"单行数据量";
    [cell showAccessory:YES image:@"iconArrow-right"];
    return cell;
  }
  ZWLabelTFCell *cell = [tableView dequeueReusableCellWithIdentifier:ZWLabelTFCellID];
  switch (indexPath.row) {
    case 0: {
      cell.labelTip.text = @"单行数据量";
    }
      break;
    case 1: {
      cell.labelTip.text = @"关系定义";
    }
      break;
    default:
      break;
  }
  [cell showBottomSeparatorLine:YES color:nil];
  [cell showAccessory:YES image:@"iconArrow-right"];
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
