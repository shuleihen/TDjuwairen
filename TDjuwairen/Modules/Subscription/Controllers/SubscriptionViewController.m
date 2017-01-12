//
//  SubscriptionViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/1/12.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "SubscriptionViewController.h"
#import "PaySubscriptionViewController.h"
#import "SubscriptionHistoryViewController.h"
#import "HexColors.h"

@interface SubscriptionViewController ()
@end

@implementation SubscriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"往期购买" style:UIBarButtonItemStylePlain target:self action:@selector(historyPressed:)];
    [right setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0f],
                                    NSForegroundColorAttributeName : [UIColor hx_colorWithHexRGBAString:@"#333333"]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = right;
    
}

- (void)historyPressed:(id)sender {
    SubscriptionHistoryViewController *vc = [[SubscriptionHistoryViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)subscriptionPressed:(id)sender {
    PaySubscriptionViewController *vc = [[UIStoryboard storyboardWithName:@"Survey" bundle:nil] instantiateViewControllerWithIdentifier:@"PaySubscriptionViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
