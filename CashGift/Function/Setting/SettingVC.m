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

@interface SettingVC ()<UITableViewDelegate, UITableViewDataSource>
{
    NSString *m_strCellID;
    UITableView *m_tableView;
}
@end

@implementation SettingVC

- (void)viewDidLoad
{
  [super viewDidLoad];
  !self.title && self.navigationController.title && (self.title = self.navigationController.title);
  // Do any additional setup after loading the view.
  [self createTableView];
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
    
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZWLabelLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:ZWLabelLabelCellID];
    switch (indexPath.row)
    {
        case 0:
        {
            cell.labelTip.text = @"数据字典";
            [cell showAccessory:YES image:@"iconArrow-right"];
            cell.labelContent.text = nil;
        }
            break;
        case 1:
        {
            cell.labelTip.text = @"版本";
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
    return cell;
}
    
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0)
    {
        DataDefineVC *vc = [[DataDefineVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.title = @"数据字典";
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
