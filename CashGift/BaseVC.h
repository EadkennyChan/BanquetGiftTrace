//
//  BaseVC.h
//  CashGift
//
//  Created by EadkennyChan on 17/2/14.
//  Copyright © 2017年 ZX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseVC : UIViewController
/*
 *  @brief：弹出选择窗，弹窗一般为UIPickerView或者UIDatePicker
 *  @param：
 *      classPicker：弹窗类名
 *      dataSource：弹窗类数据源
 */
- (nonnull UIView *)showPicker:(nonnull Class)classPicker delegate:(nullable id)dataSource okSelector:(nonnull SEL)selector;
- (void)hidePicker;

@end
