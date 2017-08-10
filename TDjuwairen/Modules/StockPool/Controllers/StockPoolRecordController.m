//
//  StockPoolRecordController.m
//  TDjuwairen
//
//  Created by ZYP-MAC on 2017/8/10.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "StockPoolRecordController.h"

@interface StockPoolRecordController ()

@end

@implementation StockPoolRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"股票池";
    self.view.backgroundColor = TDViewBackgrouondColor;
    [self configNavigationBar];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)configNavigationBar {
    // 设置title和返回按钮颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    UIImage *image = [[UIImage imageNamed:@"nav_backwhite.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = leftBar;
    
    // 设置右侧按钮（日历、分享）
    UIImage *calendarImage = [[UIImage imageNamed:@"ico_calendar.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *calendarBarBtn = [[UIBarButtonItem alloc] initWithImage:calendarImage style:UIBarButtonItemStylePlain target:self action:@selector(calendarBarBtnClick)];
    UIImage *shareImage = [[UIImage imageNamed:@"ico_share.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *shareBarBtn = [[UIBarButtonItem alloc] initWithImage:shareImage style:UIBarButtonItemStylePlain target:self action:@selector(shareBarBtnClick)];
    self.navigationItem.rightBarButtonItems = @[shareBarBtn,calendarBarBtn];
    
    
}


#pragma - action
- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}

/** 日历按钮点击事件 */
- (void)calendarBarBtnClick {

    
}

/** 分享按钮点击事件 */
- (void)shareBarBtnClick {
    
    
}

@end
