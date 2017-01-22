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
#import "NetworkManager.h"
#import "LoginState.h"
#import "UIButton+WebCache.h"

@interface PlayStockViewController ()

@end

@implementation PlayStockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"奖品兑换" style:UIBarButtonItemStylePlain target:self action:@selector(exchangePressed:)];
    
    self.view.backgroundColor = TDViewBackgrouondColor;
    
    [self queryPlayStockList];
}

- (void)queryPlayStockList {
    NetworkManager *ma = [[NetworkManager alloc] init];
    
    __weak PlayStockViewController *wself = self;
    [ma POST:API_GameImage parameters:nil completion:^(id data, NSError *error){
        
        if (!error && data) {
            [wself addImageList:data];
        } else {
            [wself addDefault];
        }
    }];
}

- (void)addImageList:(NSArray *)list {
    int i=0;
    for (NSDictionary *dict in list) {
        int type = [dict[@"game_type"] intValue];
        NSString *url = dict[@"game_imgurl"];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
            CGFloat itemH = (image.size.height/image.size.width)*kScreenWidth;
            btn.frame = CGRectMake(0, i*itemH, kScreenWidth, itemH);
        }];
        i++;
        
        if (type == 1) {
            [btn addTarget:self action:@selector(playStockIndexPressed:) forControlEvents:UIControlEventTouchUpInside];
        } else if (type == 2) {
            [btn addTarget:self action:@selector(playStockMarketPressed:) forControlEvents:UIControlEventTouchUpInside];
        }
        [self.view addSubview:btn];
    }
    
}

- (void)addDefault {
    UIImage *image = [UIImage imageNamed:@"ad_zhishu.png"];
    CGFloat itemH = (image.size.height/image.size.width)*kScreenWidth;
    
    UIButton *up = [UIButton buttonWithType:UIButtonTypeCustom];
    up.frame = CGRectMake(0, 0, kScreenWidth, itemH);
    [up setBackgroundImage:[UIImage imageNamed:@"ad_zhishu.png"] forState:UIControlStateNormal];
    [up setBackgroundImage:[UIImage imageNamed:@"ad_zhishu.png"] forState:UIControlStateHighlighted];
    [up addTarget:self action:@selector(playStockIndexPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:up];
    
    UIButton *down = [UIButton buttonWithType:UIButtonTypeCustom];
    down.frame = CGRectMake(0, CGRectGetHeight(up.frame), kScreenWidth, itemH);
    [down setBackgroundImage:[UIImage imageNamed:@"ad_mine.png"] forState:UIControlStateNormal];
    [down setBackgroundImage:[UIImage imageNamed:@"ad_mine.png"] forState:UIControlStateHighlighted];
    [down addTarget:self action:@selector(playStockMarketPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:down];
}

- (void)playStockMarketPressed:(id)sender{
//    UIViewController *vc = [[UIStoryboard storyboardWithName:@"PlayStock" bundle:nil] instantiateInitialViewController];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
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
