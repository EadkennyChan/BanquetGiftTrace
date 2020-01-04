//
//  BaseVC.m
//  CashGift
//
//  Created by EadkennyChan on 17/2/14.
//  Copyright © 2017年 ZX. All rights reserved.
//

#import "BaseVC.h"

@interface BaseVC ()
{
    UIView *m_viewBkgndSelectTime;
    UIView *m_viewSelectTime;
    UIView *m_picker;
}
@end

@implementation BaseVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - Picker

//显示收货时间选择view
- (nonnull UIView *)showPicker:(nonnull Class)classPicker delegate:(nullable id)dataSource okSelector:(SEL)selector
{
    UIControl *viewBack = [[UIControl alloc] initWithFrame:self.view.bounds];
    viewBack.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    viewBack.alpha = 0.75;
    viewBack.backgroundColor = [UIColor grayColor];
    [viewBack addTarget:self action:@selector(hidePicker) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:viewBack];
    m_viewBkgndSelectTime = viewBack;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 236)];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    m_viewSelectTime = view;
    
    UIPickerView *datePicker = [[classPicker alloc] initWithFrame:CGRectMake(0, 0, view.bounds.size.width, 200)];
    if (dataSource)
    {
        if ([datePicker respondsToSelector:@selector(setDelegate:)])
            datePicker.delegate = dataSource;
        if ([datePicker respondsToSelector:@selector(setDataSource:)])
            datePicker.dataSource = dataSource;
    }
    [view addSubview:datePicker];
    m_picker = datePicker;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 200, view.bounds.size.width, 36);
    [view addSubview:btn];
    [btn addTarget:dataSource action:selector forControlEvents:UIControlEventTouchUpInside];
    
    [UIView animateWithDuration:0.3 animations:^{
        view.frame = CGRectMake(view.frame.origin.x, self.view.bounds.size.height - view.frame.size.height, view.frame.size.width, view.frame.size.height);
    }];
    return m_picker;
}

//关闭收货时间选择view
- (void)hidePicker
{
    UIView *window = m_viewBkgndSelectTime.superview;
    
    [UIView animateWithDuration:0.3 animations:^{
        m_viewSelectTime.frame = CGRectMake(m_viewSelectTime.frame.origin.x, window.frame.size.height, m_viewSelectTime.frame.size.width, m_viewSelectTime.frame.size.height);
    } completion:^(BOOL finished) {
        [m_viewBkgndSelectTime removeFromSuperview]; m_viewBkgndSelectTime = nil; [m_viewSelectTime removeFromSuperview]; m_viewSelectTime = nil;
    }];
}

@end
