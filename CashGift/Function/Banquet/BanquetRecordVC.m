//
//  BanquetRecordVC.m
//  CashGift
//
//  Created by EadkennyChan on 17/2/10.
//  Copyright © 2017年 ZX. All rights reserved.
//

#import "BanquetRecordVC.h"
#import "UIScrollView+EmptyDataSet.h"
#import <ZWUtilityKit/ZWUtilityKit.h>
#import "EditBanquetVC.h"
#import "BanquetEntity.h"
#import "FMDB/FMDatabase.h"
#import "DBHandler.h"

@interface BanquetRecordVC ()<UITableViewDataSource, UITableViewDelegate, EmptyDataSetSource, EmptyDataSetDelegate>
{
    NSMutableArray<BanquetEntity *> *m_mtArrayData;
    NSString *m_strCellID;
    UITableView *m_tableView;
    
    UITextField *m_tfName;
}
@property (nonatomic, retain)UITextField *tfNewBanquetName;
@end

@implementation BanquetRecordVC

- (void)viewDidLoad
{
  [super viewDidLoad];
  !self.title && self.navigationController.title && (self.title = self.navigationController.title);
  [self createTableView];
  // Do any additional setup after loading the view.

  if (m_mtArrayData == nil)
      m_mtArrayData = [NSMutableArray arrayWithCapacity:1];
  [self loadBanquet];
  
  UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
  [btn setImage:[UIImage imageNamed:@"add_red"] forState:UIControlStateNormal];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
  [btn addTarget:self action:@selector(btnClickedAdd) forControlEvents:UIControlEventTouchUpInside];
}

- (void)createTableView
{
    m_strCellID = @"BanquetCellID";
    
    UITableView *tableV = [[UITableView alloc] initWithFrame:self.view.bounds];
    tableV.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tableV.backgroundColor = [UIColor clearColor];
    tableV.emptyDataSetSource = self;
    tableV.emptyDataSetDelegate = self;
    tableV.delegate = self;
    tableV.dataSource = self;
    tableV.tableFooterView = [UIView new];
    [tableV registerClass:[UITableViewCell class] forCellReuseIdentifier:m_strCellID];
    [self.view addSubview:m_tableView = tableV];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushEditBanquetVC:(BanquetEntity *)banquet
{
  EditBanquetVC *vc = [[EditBanquetVC alloc] init];
  vc.hidesBottomBarWhenPushed = YES;
  vc.title = banquet.strName;
  vc.banquet = banquet;
  if (![banquet getParticipants])
  {
    [DBHandler loadParticipants:banquet];
  }
  [self.navigationController pushViewController:vc animated:YES];
}

- (void)loadBanquet
{
  NSArray *arr = [DBHandler loadBanquetList];
  if (arr.count == 0) {
    arr = [self loadFromPlist];
  }
  m_mtArrayData = [NSMutableArray arrayWithArray:arr];
}

- (NSArray *)loadFromPlist {
  BanquetEntity *banquet = [[BanquetEntity alloc] init];
  banquet.strName = @"捐款明细";
  
  NSBundle *bundle = [NSBundle mainBundle];
  NSString *strPath = [bundle pathForResource:@"捐款名单" ofType:@"plist"];
  NSArray *arr = [NSArray arrayWithContentsOfFile:strPath];
  
  NSMutableArray *mtArr = [NSMutableArray arrayWithCapacity:arr.count];
  ParticipantEntity *item;
  for (NSDictionary *dic in arr) {
    item = [[ParticipantEntity alloc] initWithDictionary:dic];
    [mtArr addObject:item];
  }
  [banquet setParticipants:mtArr];
  return @[banquet];
}
/*
{
    NSString *strPath = [ConfigSetting dataDirectoryPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *arrayLogFileList = [[fileManager contentsOfDirectoryAtPath:strPath error:nil]
                                 pathsMatchingExtensions:[NSArray arrayWithObject:@"db"]] ;
    for (NSString *file in arrayLogFileList)
    {
        [m_mtArrayData addObject:[BanquetEntity banquetWithDBPath:strPath fileName:file]];
    }
}*/

- (void)addBanquet:(NSString *)name
{
  if (name.length > 0)
  {
    BanquetEntity *banquet = [BanquetEntity banquetWithName:name];
    [m_mtArrayData addObject:banquet];
    [m_tableView reloadData];
    [DBHandler addBanquet:banquet];
    [self performSelectorOnMainThread:@selector(pushEditBanquetVC:) withObject:banquet waitUntilDone:NO];
  }
}

#pragma mark - btn clicked
  
- (void)btnClickedAdd
{
  NSString *strTitle = @"请输入酒席名称";
  UIAlertController *alert = [UIAlertController alertControllerWithTitle:strTitle message:nil preferredStyle:UIAlertControllerStyleAlert];
  NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:strTitle];
  [alertControllerStr addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(50, 50, 50) range:NSMakeRange(0, strTitle.length)];
  [alertControllerStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, strTitle.length)];
  [alert setValue:alertControllerStr forKey:@"attributedTitle"];

  WeakObject(self);
  [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
    textField.font = [UIFont systemFontOfSize:15];
    StrongObject(self);
    strongObject.tfNewBanquetName = textField;
  }];
  [self presentViewController:alert animated:YES completion:nil];
  UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
  [cancelAction setValue:RGBCOLOR(3, 169, 244) forKey:@"_titleTextColor"];
  [alert addAction:cancelAction];
  UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    StrongObject(self);
    if (strongObject.tfNewBanquetName.text.length == 0)
    {
      [SVProgressHUD showErrorWithStatus:@"请输入宴会名称"];
      return;
    }
    [strongObject addBanquet:strongObject.tfNewBanquetName.text];
  }];
//  [actionSetting setValue:COLOR_MAIN forKey:@"_titleTextColor"];
  [alert addAction:actionOk];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_mtArrayData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:m_strCellID];
    if (indexPath.row >= m_mtArrayData.count)
    {
        cell.textLabel.text = @"新建";
    }
    else
    {
        BanquetEntity *banquet = m_mtArrayData[indexPath.row];
        NSString *strText = [NSString stringWithFormat:@"%@(%@)", banquet.strName, banquet.strDate];
        cell.textLabel.text = strText;
    }
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row >= m_mtArrayData.count)
    {
      [self btnClickedAdd];
    }
    else
    {
        BanquetEntity *banquet = m_mtArrayData[indexPath.row];
        [self pushEditBanquetVC:banquet];
    }
}
#pragma mark - DZNEmptyDataSetSource

- (nullable NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *strText = nil;
//    switch (self.nRequestStatus)
//    {
//        case RequestStatus_NoData:
//            strText = @"您还没有记录哦";
//            break;
//        case RequestStatus_Requesting:
//            strText = @"正在加载";
//            break;
//        case RequestStatus_NoNetwork:
//            strText = @"未检测到网络，请稍后点击重试";
//            break;
//        case RequestStatus_TimeOut:
//            strText = @"请求超时";
//            break;
//        case RequestStatus_ConnectionLost:
//            strText = @"网络中断，请点击重试";
//            break;
//        case RequestStatus_ServerException:
//            strText = @"服务器异常，请点击重试";
//            break;
//        default:
            strText = @"您还没有数据哦";
//            break;
//    }
    return [self defaultTitleStyleForEmptyData:strText];
}

- (NSMutableAttributedString *)defaultTitleStyleForEmptyData:(NSString *)strText
{
    NSMutableAttributedString *mtAttrStr = nil;
    if (strText.length > 0)
    {
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        paragraphStyle.alignment = NSTextAlignmentCenter;
        
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:14.0],
                                     NSForegroundColorAttributeName: RGBCOLOR(170, 170, 170),
                                     NSParagraphStyleAttributeName: paragraphStyle};
        mtAttrStr = [[NSMutableAttributedString alloc] initWithString:strText attributes:attributes];
    }
    return mtAttrStr;
}

@end
