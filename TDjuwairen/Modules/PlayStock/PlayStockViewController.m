//
//  PlayStockViewController.m
//  TDjuwairen
//
//  Created by zdy on 2016/12/16.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "PlayStockViewController.h"
#import "KeysExchangeViewController.h"
#import "LoginViewController.h"

#import "LoginState.h"

@interface PlayStockViewController ()

@end

@implementation PlayStockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"奖品兑换" style:UIBarButtonItemStylePlain target:self action:@selector(exchangePressed:)];
    
    CGFloat itemH = 190;
//    UIImage *image = [UIImage imageNamed:@"ad_zhishu.png"];
    
    UIButton *up = [UIButton buttonWithType:UIButtonTypeCustom];
    up.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, itemH);
    [up setBackgroundImage:[UIImage imageNamed:@"ad_zhishu.png"] forState:UIControlStateNormal];
    [up setBackgroundImage:[UIImage imageNamed:@"ad_zhishu.png"] forState:UIControlStateHighlighted];
    [up addTarget:self action:@selector(playStockIndexPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:up];
    
    UIButton *down = [UIButton buttonWithType:UIButtonTypeCustom];
    down.frame = CGRectMake(0, itemH, [UIScreen mainScreen].bounds.size.width, itemH);
    [down setBackgroundImage:[UIImage imageNamed:@"ad_mine.png"] forState:UIControlStateNormal];
    [down setBackgroundImage:[UIImage imageNamed:@"ad_mine.png"] forState:UIControlStateHighlighted];
//    [down addTarget:self action:@selector(playStockIndexPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:down];
}


- (void)playStockMarketPressed:(id)sender{
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"PlayStock" bundle:nil] instantiateInitialViewController];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)playStockIndexPressed:(id)sender{
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"PlayStock" bundle:nil] instantiateViewControllerWithIdentifier:@"StockIndexViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)exchangePressed:(id)sender {
    if (US.isLogIn) {
        //进入钥匙兑换页
        KeysExchangeViewController *keysExchange = [[KeysExchangeViewController alloc] init];
        keysExchange.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:keysExchange animated:YES];
    }
    else
    {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
    }
}
@end
