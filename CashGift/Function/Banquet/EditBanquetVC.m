//
//  EditBanquetVC.m
//  CashGift
//
//  Created by EadkennyChan on 17/2/14.
//  Copyright © 2017年 ZX. All rights reserved.
//

#import "EditBanquetVC.h"
#import <ZWMultiColView/ZWMultiColTableView.h>
#import "AddParticipantVC.h"
#import "WXApi.h"
#import <ZWUtilityKit/UIImage+StrethImage.h>
#import <ZWUtilityKit/NSDictionary+NSData.h>
#import "DBHandler.h"

@interface EditBanquetVC ()<ZWMultiColTableViewDataSource>
{
    NSArray *m_arrayTitle;
    ZWMultiColTableView *m_multiTbv;
}
@end

@implementation EditBanquetVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    m_arrayTitle = @[@"姓名", @"金额", @"回礼", @"关系"];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = RGBCOLOR(3, 169, 244);
    [btn setTitle:@"添加" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClickedAdd)forControlEvents:UIControlEventTouchUpInside];
    btn.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    btn.layer.cornerRadius = 4;
    btn.layer.masksToBounds = YES;
    [self.view addSubview:btn];
    CGRect frame = CGRectInset(self.view.bounds, 30, 0);
    frame.size.height = 45;
    frame.origin.y = self.view.bounds.size.height - frame.size.height - 8;
    btn.frame = frame;
    
    frame = self.view.bounds;
    frame.size.height = self.view.bounds.size.height - 60;
    ZWMultiColTableView *tbvMulti = [[ZWMultiColTableView alloc] initWithFrame:frame];
    tbvMulti.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    tbvMulti.bAutoAdjustGridWidthToFitText = YES;
    tbvMulti.dataSource = self;
    tbvMulti.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:m_multiTbv = tbvMulti];
    
    UIButton* btnScan = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    [btnScan setTitle:@"分享" forState:UIControlStateNormal];
    [btnScan setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnScan.titleLabel.font = [UIFont systemFontOfSize:16];
    [btnScan addTarget:self action:@selector(btnClickedShare)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc]initWithCustomView:btnScan];
    self.navigationItem.rightBarButtonItems = @[rightItem];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)btnClickedAdd
{
  AddParticipantVC *vc = [[AddParticipantVC alloc] init];
  vc.arrayItemTitle = m_arrayTitle;
  
  WeakObject(self);
  vc.blockFinished = ^(ParticipantEntity *participant) {
    StrongObject(self);
    [DBHandler addParticipant:participant toBanquet:strongObject.banquet];
    [strongObject->m_multiTbv reloadData];
  };
  [self.navigationController pushViewController:vc animated:YES];
}

- (void)btnClickedShare//通过第三方社交软件分享
{
    CGRect frame = self.view.bounds;
    frame.size.height = ([_banquet getParticipants].count + 2) * 44;
    UIView *viewRoot = [[UIView alloc] initWithFrame:frame];
    frame = viewRoot.bounds;
    frame.size.height = 44;
    UILabel *l = [[UILabel alloc] initWithFrame:frame];
    l.font = [UIFont systemFontOfSize:15];
    l.text = self.title;
    l.textAlignment = NSTextAlignmentCenter;
    l.backgroundColor = [UIColor whiteColor];
    [viewRoot addSubview:l];
    frame.origin.y += frame.size.height;
    frame.size.height = viewRoot.bounds.size.height - frame.origin.y;
    ZWMultiColTableView *tbvMulti = [[ZWMultiColTableView alloc] initWithFrame:frame];
    tbvMulti.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [viewRoot addSubview:tbvMulti];
    //    tbvMulti.bAutoAdjustGridWidthToFitText = YES;
    tbvMulti.dataSource = self;
    tbvMulti.backgroundColor = [UIColor whiteColor];
    [tbvMulti reloadData];
    [tbvMulti layoutIfNeeded];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self shareToWeChat:WXSceneSession data:nil image:[self getDoodleImage:viewRoot]];
    });
//    UIImageWriteToSavedPhotosAlbum([self getDoodleImage], self, @selector(imageSavedToPhotosAlbum: didFinishSavingWithError: contextInfo:), nil);
}

- (void)saveFinished
{
    
}
/*
 *  @brief:获取编辑的效果图
 */
- (UIImage *)getDoodleImage:(UIView *)viewCapture
{
    UIGraphicsBeginImageContextWithOptions(viewCapture.bounds.size, NO, [UIScreen mainScreen].scale);
    [viewCapture drawViewHierarchyInRect:viewCapture.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - savePhotoAlbumDelegate

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *) contextInfo
{
    NSString *message;
    if (!error)
    {
        message = @"成功保存到相册";
    }
}

#pragma mark - 分享

- (void)shareToWeChat:(int)scene data:(NSDictionary *)dicData image:(UIImage *)image
{
    WXImageObject *ext = [WXImageObject object];
    ext.imageData = UIImagePNGRepresentation(image);
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = self.title;
    message.description = self.title;
    message.mediaObject = ext;
    message.messageExt = nil;
    message.messageAction = nil;
    message.mediaTagName = nil;
    [message setThumbImage:[UIImage generatePhotoThumbnail:image]];
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.scene = scene;
    req.message = message;
    
    [WXApi sendReq:req];
}

#pragma mark - ZWMultiColTableViewDataSource

- (NSInteger)ZWMultiColTableView:(ZWMultiColTableView*)multiColTableView numberOfRowsInSection:(NSInteger)section
{
    return [_banquet getParticipants].count;
}

- (NSInteger)numberOfColumn:(ZWMultiColTableView*)multiColTableView
{
    return m_arrayTitle.count;
}

- (void)ZWMultiColTableView:(ZWMultiColTableView*)multiColTableView setContentForTopGridCell:(UIView *)gridCell atColumn:(NSInteger)nCol
{
    UILabel *l = (UILabel *)gridCell;
    l.textAlignment = NSTextAlignmentCenter;
    l.text = m_arrayTitle[nCol];
}

- (void)ZWMultiColTableView:(ZWMultiColTableView*)multiColTableView setContentForGridCell:(UIView *)gridCell atIndexPath:(NSIndexPath *)indexPath atColumn:(NSInteger)nCol
{
    UILabel *l = (UILabel *)gridCell;
    l.textAlignment = NSTextAlignmentCenter;
    ParticipantEntity *participant = [_banquet getParticipants][indexPath.row];
    switch (nCol)
    {
        case 0:
            l.text = participant.strName;
            break;
        case 1:
            l.text = [NSString stringWithFormat:@"%.2f", participant.fAmount];
            break;
        case 2:
        {
            NSString *strText = @"";
            for (NSString *strReturn in participant.arrayReturn)
            {
                strText = [strText stringByAppendingString:strReturn];
            }
            if (strText.length == 0)
                l.text = @"无";
            else
                l.text = strText;
        }
            break;
        case 3:
            l.text = participant.strRelation;
            break;
        default:
            break;
    }
}

- (void)ZWMultiColTableView:(ZWMultiColTableView *)multiColTableView needAdjustWidth:(CGFloat)fWidth
{
    
}

- (CGFloat)ZWMultiColTableView:(ZWMultiColTableView*)multiColTableView widthAtColumn:(NSInteger)nCol
{
    return multiColTableView.frame.size.width / m_arrayTitle.count;
}

@end
