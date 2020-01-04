//
//  AddParticipantVC.m
//  CashGift
//
//  Created by EadkennyChan on 17/2/14.
//  Copyright © 2017年 ZX. All rights reserved.
//

#import "AddParticipantVC.h"
#import "UIScrollView+EmptyDataSet.h"
#import <ZWUtilityKit/ZWTableViewCell.h>
#import <ZWUtilityKit/ZWButtonCell.h>
#import <ZWUtilityKit/ZWUtilityKit.h>
#import "ParticipantEntity.h"

@interface AddParticipantVC ()<UITableViewDataSource, UITableViewDelegate, ZWLabelTFDelegate, UITextFieldDelegate>
{
  UITableView *m_tableView;
  ParticipantEntity *m_participant;
  NSArray *m_arrayReturn;//回礼
  NSArray *m_arrayRelation;
  
  NSInteger m_nIndexCurSeleted;//当前正在选择“回礼/关系”
  UIPickerView *m_picker;
  
  UITextField *m_tfName;
  UITextField *m_tfAmount;
}
@end

@implementation AddParticipantVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createTableView];
    m_arrayReturn = [[ConfigSetting loadReturnGift] copy];
    m_arrayRelation = [[ConfigSetting loadRelation] copy];
    m_participant = [[ParticipantEntity alloc] init];
    m_participant.arrayReturn = [NSArray arrayWithObjects:m_arrayReturn.firstObject, nil];
    m_participant.strRelation = m_arrayRelation.firstObject;
}

- (void)createTableView
{
  UITableView *tableV = [[UITableView alloc] initWithFrame:self.view.bounds];
  tableV.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  tableV.backgroundColor = [UIColor clearColor];
  tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
  tableV.delegate = self;
  tableV.dataSource = self;
  tableV.tableFooterView = [UIView new];
  [tableV registerClass:[ZWLabelTFCell class] forCellReuseIdentifier:ZWLabelTFCellID];
  [tableV registerClass:[ZWLabelLabelCell class] forCellReuseIdentifier:ZWLabelLabelCellID];
  [tableV registerClass:[ZWButtonCell class] forCellReuseIdentifier:ZWButtonCellID];
  
  [self.view addSubview:m_tableView = tableV];
  
//  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDidScroll:)];
//  [tableV addGestureRecognizer:tap];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
  if (m_participant.strName.length == 0)
  {
    [m_tfName becomeFirstResponder];
  }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)btnClickedDone
{
  [self.view endEditing:YES];

  if (m_participant.strName.length == 0)
  {
    [SVProgressHUD showErrorWithStatus:@"请输入姓名"];
    return;
  }
  else if (m_participant.fAmount <= 0)
  {
    [SVProgressHUD showErrorWithStatus:@"请输入金额"];
    return;
  }
  if (_blockFinished)
    _blockFinished(m_participant);
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)selectDone
{
  switch (m_nIndexCurSeleted)
  {
    case 2:
    {
      NSString *strReturn = m_arrayReturn[[m_picker selectedRowInComponent:0]];
      m_participant.arrayReturn = [NSArray arrayWithObjects:strReturn, nil];
    }
      break;
    case 3:
      m_participant.strRelation = m_arrayRelation[[m_picker selectedRowInComponent:0]];
      break;
    default:
      break;
  }
  [self hidePicker];
  [m_tableView reloadData];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayItemTitle.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell;
  if (indexPath.row < 2)
  {
    ZWLabelTFCell *cellTF = [tableView dequeueReusableCellWithIdentifier:ZWLabelTFCellID];
    [cellTF showBottomSeparatorLine:YES color:nil];
    cellTF.fWidthTip = 65;
    cellTF.labelTip.text = _arrayItemTitle[indexPath.row];
    cell = cellTF;
    if (indexPath.row == 1)
    {
      cellTF.tfContent.keyboardType = UIKeyboardTypeDecimalPad;
      m_tfAmount = cellTF.tfContent;
      if (m_participant.fAmount > 0)
          cellTF.tfContent.text = [NSString stringWithFormat:@"%.2f", m_participant.fAmount];
    }
    else
    {
      cellTF.tfContent.keyboardType = UIKeyboardTypeDefault;
      cellTF.tfContent.returnKeyType = UIReturnKeyNext;
      cellTF.tfContent.text = m_participant.strName;
      m_tfName = cellTF.tfContent;
    }
    cellTF.tfContent.clearButtonMode = UITextFieldViewModeWhileEditing;
    cellTF.tfContent.textAlignment = NSTextAlignmentRight;
    cellTF.delegate = self;
    cellTF.tfContent.delegate = self;
    cellTF.tfContent.tag = indexPath.section * 10 + indexPath.row;
  }
  else if (indexPath.row < _arrayItemTitle.count)//回礼
  {
    ZWLabelLabelCell *cellLL = [tableView dequeueReusableCellWithIdentifier:ZWLabelLabelCellID];
    [cellLL showBottomSeparatorLine:YES color:nil];
    cellLL.fWidthTip = 65;
    cellLL.labelTip.text = _arrayItemTitle[indexPath.row];
    cell = cellLL;
    if (indexPath.row == 2)
    {
      if (m_participant.arrayReturn.count == 0)
      {
        cellLL.labelContent.text = @"无";
      }
      else
      {
        NSString *strReturn = @"";
        for (NSString *str in m_participant.arrayReturn)
        {
            strReturn = [strReturn stringByAppendingFormat:@"%@ + ", str];
        }
        strReturn = [strReturn substringToIndex:strReturn.length - 3];
        cellLL.labelContent.text = strReturn;
      }
    }
    else if (indexPath.row == 3)
    {
      if (m_participant.strRelation.length == 0)
      {
        cellLL.labelContent.text = @"无";
      }
      else
      {
        cellLL.labelContent.text = m_participant.strRelation;
      }
    }
    cellLL.labelContent.textAlignment = NSTextAlignmentRight;
  }
  else
  {
    ZWButtonCell *cellBtn = [tableView dequeueReusableCellWithIdentifier:ZWButtonCellID];
    [cellBtn setButtonInset:UIEdgeInsetsMake(30, 30, 30, 30)];
    cellBtn.btn.layer.cornerRadius = 4.0;
    cellBtn.btn.backgroundColor = RGBCOLOR(3, 169, 244);
    [cellBtn.btn setTitle:@"完成" forState:UIControlStateNormal];
    [cellBtn.btn addTarget:self action:@selector(btnClickedDone) forControlEvents:UIControlEventTouchUpInside];
    cell = cellBtn;
  }
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  [self.view endEditing:YES];
  switch (indexPath.row)
  {
      case 2:
      {
          if (m_arrayReturn.count == 0)
              return;
          m_nIndexCurSeleted = indexPath.row;
          m_picker = (UIPickerView *)[self showPicker:[UIPickerView class] delegate:self okSelector:@selector(selectDone)];
      }
          break;
      case 3:
      {
          if (m_arrayRelation.count == 0)
              return;
          m_nIndexCurSeleted = indexPath.row;
          m_picker = (UIPickerView *)[self showPicker:[UIPickerView class] delegate:self okSelector:@selector(selectDone)];
      }
          break;
      default:
          break;
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= _arrayItemTitle.count)
        return 105;
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8.0;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  [self.view endEditing:YES];
}

#pragma mark - ZWLabelTFDelegate

- (void)labelTfDidEndEditing:(ZWLabelTFCell *)labelTF
{
  NSIndexPath *indexPath = [m_tableView indexPathForCell:labelTF];
  switch (indexPath.row)
  {
    case 0:
        m_participant.strName = labelTF.tfContent.text;
        break;
    case 1:
        m_participant.fAmount = labelTF.tfContent.text.floatValue;
        break;
    default:
        break;
  }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  if (textField.tag == 0 && textField == m_tfName)
  {
    [m_tfAmount becomeFirstResponder];
  }
  else
  {
    [textField resignFirstResponder];
  }
  return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
  if (textField.tag == 0 && textField == m_tfName)
  {
    m_participant.strName = textField.text;
  }
  else if (textField.tag == 1)
  {
    m_participant.fAmount = textField.text.floatValue;
    m_tfAmount.text = [NSString stringWithFormat:@"%.2f", m_participant.fAmount];
  }
}

#pragma mark - UIPickerViewDataSource

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{
    UILabel *l = [[UILabel alloc] init];
    l.backgroundColor = [UIColor clearColor];
    l.textAlignment = NSTextAlignmentCenter;
    l.font = [UIFont systemFontOfSize:20];
    NSArray *arrayDatas;
    switch (m_nIndexCurSeleted)
    {
        case 2:
            arrayDatas = m_arrayReturn;
            break;
        case 3:
            arrayDatas = m_arrayRelation;
            break;
        default:
            break;
    }
    l.text = arrayDatas[row];
    return l;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component)
    {
        case 0:
//            m_arrayCity = [[m_arrayProvince objectAtIndex:row] objectForKey:@"SubItems"];
//            [pickerView selectRow:0 inComponent:1 animated:NO];
//            [pickerView reloadComponent:1];
//            m_arrayDistrict = [[m_arrayCity objectAtIndex:0] objectForKey:@"SubItems"];
//            [pickerView selectRow:0 inComponent:2 animated:NO];
//            [pickerView reloadComponent:2];
            break;
        case 1:
//            m_arrayDistrict = [[m_arrayCity objectAtIndex:row] objectForKey:@"SubItems"];
//            [pickerView selectRow:0 inComponent:2 animated:NO];
//            [pickerView reloadComponent:2];
            break;
        default:
            break;
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger nRet = 0;
    switch (m_nIndexCurSeleted)
    {
        case 2:
            nRet = m_arrayReturn.count;
            break;
        case 3:
            nRet = m_arrayRelation.count;
            break;
        default:
            break;
    }
    return nRet;
}

@end
