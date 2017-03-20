//
//  PlayIndividualStockViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/3/20.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "PlayIndividualStockViewController.h"
#import "UIViewController+Login.h"
#import "LoginState.h"
#import "MyWalletViewController.h"
#import "MyGuessViewController.h"
#import "TDWebViewController.h"
#import "PushMessageViewController.h"

@interface PlayIndividualStockViewController ()

@end

@implementation PlayIndividualStockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Action
- (IBAction)walletPressed:(id)sender {
    if (!US.isLogIn) {
        [self pushLoginViewController];
    } else {
        MyWalletViewController *myWallet = [[MyWalletViewController alloc] init];
        [self.navigationController pushViewController:myWallet animated:YES];
    }
}

- (IBAction)myGuessPressed:(id)sender {
    if (!US.isLogIn) {
        [self pushLoginViewController];
    } else {
        MyGuessViewController *vc = [[MyGuessViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)rulePressed:(id)sender {
    NSURL *url = [NSURL URLWithString:@"https://appapi.juwairen.net/Page/index/p/jingcaiguize"];
    TDWebViewController *vc = [[TDWebViewController alloc] initWithURL:url];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)messagePressed:(id)sender {
    if (US.isLogIn==NO) {
        [self pushLoginViewController];
    } else {
        PushMessageViewController *messagePush = [[PushMessageViewController alloc]init];
        messagePush.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:messagePush animated:YES];
    }
}

- (void)commentPressed:(id)sender {
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"PlayStock" bundle:nil] instantiateViewControllerWithIdentifier:@"PlayStockCommentViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
