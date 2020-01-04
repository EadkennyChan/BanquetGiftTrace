//
//  DataDefineVC.m
//  CashGift
//
//  Created by EadkennyChan on 17/2/16.
//  Copyright © 2017年 ZX. All rights reserved.
//

#import "DataDefineVC.h"
#import <ZWUtilityKit/ZWTableViewCell.h>
#import "DataSetVC.h"

@interface DataDefineVC ()<UITableViewDelegate, UITableViewDataSource, DataSettingChangedDelegate>
{
    UITableView *m_tableView;
    
    NSMutableArray *m_mtArrayReturn;
    NSMutableArray *m_mtArrayRelation;
    NSInteger m_nIndexCurSelected;
}
@end

@implementation DataDefineVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createTableView];
    m_mtArrayReturn = [ConfigSetting loadReturnGift];
    m_mtArrayRelation = [ConfigSetting loadRelation];
}

- (void)createTableView
{
    UITableView *tableV = [[UITableView alloc] initWithFrame:self.view.bounds];
    tableV.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tableV.backgroundColor = [UIColor clearColor];
    tableV.delegate = self;
    tableV.dataSource = self;
    tableV.tableFooterView = [UIView new];
    tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:m_tableView = tableV];
    [tableV registerClass:[ZWLabelTipCell class] forCellReuseIdentifier:ZWLabelTipCellID];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    m_nIndexCurSelected = -1;
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
    ZWLabelTipCell *cell = [tableView dequeueReusableCellWithIdentifier:ZWLabelTipCellID];
    switch (indexPath.row)
    {
        case 0:
        {
            cell.labelTip.text = @"回礼设置";
        }
            break;
        case 1:
        {
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    m_nIndexCurSelected = indexPath.row;
    DataSetVC *vc = [[DataSetVC alloc] init];
    vc.delegate = self;
    switch (indexPath.row)
    {
        case 0:
        {
            vc.mtArrayData = m_mtArrayReturn;
//            vc.mtArrayData = [NSMutableArray arrayWithObjects:@"烟", @"喜糖", nil];
        }
            break;
        case 1:
        {
            vc.mtArrayData = m_mtArrayRelation;
        }
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 

- (void)dataSettingDidChanged:(nullable NSArray *)arrayData
{
    switch (m_nIndexCurSelected)
    {
        case 0:
        {
            [ConfigSetting saveReturnGiftDataToFile:m_mtArrayReturn];
        }
            break;
        case 1:
        {
            [ConfigSetting saveRelationDataToFile:m_mtArrayRelation];
        }
            break;
        default:
            break;
    }
}

@end
