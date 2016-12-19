//
//  PlayStockViewController.m
//  TDjuwairen
//
//  Created by zdy on 2016/12/16.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "PlayStockViewController.h"

@interface PlayStockViewController ()

@end

@implementation PlayStockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"奖品兑换" style:UIBarButtonItemStylePlain target:self action:@selector(exchangePressed:)];
    
    CGFloat itemH = ([UIScreen mainScreen].bounds.size.height-64-50)/2;
    
    UIButton *up = [UIButton buttonWithType:UIButtonTypeCustom];
    up.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, itemH);
    [up setBackgroundImage:[UIImage imageNamed:@"bg_wanpiaocaihonglv.png"] forState:UIControlStateNormal];
    [up setBackgroundImage:[UIImage imageNamed:@"bg_wanpiaocaihonglv.png"] forState:UIControlStateHighlighted];
    [up addTarget:self action:@selector(playStockMarketPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:up];
    
    UIButton *down = [UIButton buttonWithType:UIButtonTypeCustom];
    down.frame = CGRectMake(0, itemH, [UIScreen mainScreen].bounds.size.width, itemH);
    [down setBackgroundImage:[UIImage imageNamed:@"bg_bishuizhun.png"] forState:UIControlStateNormal];
    [down setBackgroundImage:[UIImage imageNamed:@"bg_bishuizhun.png"] forState:UIControlStateHighlighted];
    [down addTarget:self action:@selector(playStockIndexPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:down];
}


- (void)playStockMarketPressed:(id)sender{
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"PlayStock" bundle:nil] instantiateInitialViewController];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)playStockIndexPressed:(id)sender{
    
}

- (void)exchangePressed:(id)sender {
    
}
@end
