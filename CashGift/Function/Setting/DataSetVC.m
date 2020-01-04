//
//  DataSetVC.m
//  CashGift
//
//  Created by EadkennyChan on 17/2/16.
//  Copyright © 2017年 ZX. All rights reserved.
//

#import "DataSetVC.h"
#import <ZWUtilityKit/ZWTableViewCell.h>
#import <ZWUtilityKit/ZWButtonCell.h>

@interface DataSetVC ()<UITableViewDelegate, UITableViewDataSource, ZWLabelTFDelegate, UITextFieldDelegate>
{
    UITableView *m_tableView;
    BOOL m_bIsAdding;//需要添加数据的标志
}
@end

@implementation DataSetVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createTableView];
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
    [tableV registerClass:[ZWLabelTFCell class] forCellReuseIdentifier:ZWLabelTFCellID];
    [tableV registerClass:[ZWButtonCell class] forCellReuseIdentifier:ZWButtonCellID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)btnClickedAdd
{
    m_bIsAdding = YES;
    [m_tableView reloadData];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger nRet = _mtArrayData.count + 1;
    if (m_bIsAdding)
        nRet++;
    return nRet;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell;
  if (indexPath.row < _mtArrayData.count || (m_bIsAdding && indexPath.row == _mtArrayData.count))
  {
    ZWLabelTFCell *cellTF = [tableView dequeueReusableCellWithIdentifier:ZWLabelTFCellID];
    cellTF.delegate = self;
    cellTF.tfContent.textAlignment = NSTextAlignmentCenter;
    [cellTF showBottomSeparatorLine:YES color:nil];
    cell = cellTF;
    if (indexPath.row < _mtArrayData.count)
    {
      cellTF.tfContent.text = _mtArrayData[indexPath.row];
    }
    else
    {
      dispatch_async(dispatch_get_main_queue(), ^{[cellTF.tfContent becomeFirstResponder];});
    }
    cellTF.labelTip.hidden = YES;
  }
  else
  {
    ZWButtonCell *btnCell = [tableView dequeueReusableCellWithIdentifier:ZWButtonCellID];
    [btnCell setButtonInset:UIEdgeInsetsMake(15, 30, 15, 30)];
    btnCell.btn.layer.cornerRadius = 4.0;
    btnCell.btn.backgroundColor = RGBCOLOR(3, 169, 244);
    [btnCell.btn setTitle:@"添加" forState:UIControlStateNormal];
    [btnCell.btn addTarget:self action:@selector(btnClickedAdd) forControlEvents:UIControlEventTouchUpInside];
    cell = btnCell;
  }
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > _mtArrayData.count || (!m_bIsAdding && indexPath.row == _mtArrayData.count))
        return 75;
    return 44;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
  
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  return YES;
}

#pragma mark - ZWLabelTFDelegate

- (void)labelTfDidEndEditing:(ZWLabelTFCell *)labelTF
{
    NSIndexPath *indexPath = [m_tableView indexPathForCell:labelTF];
    if (m_bIsAdding && indexPath.row == _mtArrayData.count)
    {
        m_bIsAdding = NO;
        if (labelTF.tfContent.text.length == 0)
        {
            [m_tableView reloadData];
            return;
        }
        [_mtArrayData addObject:labelTF.tfContent.text];
        if ([_delegate respondsToSelector:@selector(dataSettingDidChanged:)])
        {
            [_delegate dataSettingDidChanged:_mtArrayData];
        }
    }
    else
    {
        if (labelTF.tfContent.text.length == 0)
        {
            [SVProgressHUD showErrorWithStatus:@"请输入新的内容"];
            [m_tableView reloadData];
            return;
        }
        else
        {
            NSString *strOldValue = _mtArrayData[indexPath.row];
            if (![strOldValue isEqualToString:labelTF.tfContent.text])
            {
                [_mtArrayData replaceObjectAtIndex:indexPath.row withObject:labelTF.tfContent.text];
                if ([_delegate respondsToSelector:@selector(dataSettingDidChanged:)])
                {
                    [_delegate dataSettingDidChanged:_mtArrayData];
                }
            }
        }
    }
}

@end
