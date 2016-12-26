//
//  StockUnlockViewController.m
//  TDjuwairen
//
//  Created by zdy on 2016/12/21.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "StockUnlockViewController.h"
#import "NetworkManager.h"
#import "LoginState.h"
#import "RechargeViewController.h"
#import "NotificationDef.h"
#import "STPopup.h"

@interface StockUnlockViewController ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *stockNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *keyNumberBtn;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;

@end

@implementation StockUnlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.contentSizeInPopup = CGSizeMake(260, 200);
    
    if (US.isLogIn) {
        NSDictionary *para = @{@"user_id":US.userId};
        NetworkManager *ma = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
        [ma POST:API_QueryKeyNumber parameters:para completion:^(id data, NSError *error){
            if (!error) {
                long keyNumber = [data[@"keyNum"] longValue];
                [self setupDataWithKeyNumber:keyNumber];
            } else {
                //
            }
        }];
    }
}

- (void)setupDataWithKeyNumber:(long)keyNumber {
    self.balanceLabel.text = [NSString stringWithFormat:@"账户余额  %ld",keyNumber];
    if (keyNumber > 1) {
        [self.doneBtn setTitle:@"解锁" forState:UIControlStateNormal];
        [self.doneBtn setTitle:@"解锁" forState:UIControlStateHighlighted];
        [self.doneBtn addTarget:self action:@selector(unlockPressed:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [self.doneBtn setTitle:@"充值" forState:UIControlStateNormal];
        [self.doneBtn setTitle:@"充值" forState:UIControlStateHighlighted];
        [self.doneBtn addTarget:self action:@selector(rechargePressed:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)unlockPressed:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kSurveyDetailUnlock object:nil];
    }];
}

- (void)rechargePressed:(id)sender {
    RechargeViewController *vc = [[UIStoryboard storyboardWithName:@"Recharge" bundle:nil] instantiateViewControllerWithIdentifier:@"RechargeViewController"];
    
    [self.popupController pushViewController:vc animated:YES];
}

@end