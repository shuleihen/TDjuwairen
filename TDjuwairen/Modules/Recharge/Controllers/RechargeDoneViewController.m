//
//  RechargeDoneViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/8/22.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "RechargeDoneViewController.h"

@interface RechargeDoneViewController ()

@end

@implementation RechargeDoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setupUI {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [self.view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, CGRectGetMaxY(imageView.frame), kScreenWidth-24, 14)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = TDTitleTextColor;
    label.text = @"充值成功";
    
    
}

@end
