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
#import "NotificationDef.h"
#import "STPopup.h"

@interface StockUnlockViewController ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *stockNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *keyNumberBtn;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
@property (weak, nonatomic) IBOutlet UIButton *vipBtn;
@property (assign, nonatomic) NSInteger balanceKey;
@end

@implementation StockUnlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.contentSizeInPopup = CGSizeMake(210, 220);
    
    if (!US.isLogIn) {
        return;
    }
    
    self.stockNameLabel.text = [NSString stringWithFormat:@"%@(%@)",self.model.stockName,self.model.stockCode];
    [self.keyNumberBtn setTitle:[NSString stringWithFormat:@"%ld",self.model.unlockKeyNum] forState:UIControlStateNormal];
    
    [self.vipBtn setTitle:self.model.vipDesc forState:UIControlStateNormal];
    [self.vipBtn setTitle:self.model.vipDesc forState:UIControlStateHighlighted];
    
    if (self.model.userKeyNum >= self.model.unlockKeyNum) {
        self.balanceLabel.text = [NSString stringWithFormat:@"账户余额  %ld",self.model.userKeyNum];
        [self.doneBtn setTitle:@"立即解锁" forState:UIControlStateNormal];
        [self.doneBtn setTitle:@"立即解锁" forState:UIControlStateHighlighted];
        [self.doneBtn addTarget:self action:@selector(unlockPressed:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        self.balanceLabel.text = @"账户余额不足";
        [self.doneBtn setTitle:@"购买钥匙" forState:UIControlStateNormal];
        [self.doneBtn setTitle:@"购买钥匙" forState:UIControlStateHighlighted];
        [self.doneBtn addTarget:self action:@selector(rechargePressed:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)unlockPressed:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(unlockWithStockCode:)]) {
        [self.delegate unlockWithStockCode:self.model.stockCode];
    }
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)rechargePressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(rechargePressed:)]) {
        [self.delegate rechargePressed:sender];
    }
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)closePressed:(id)sender {
    [self.popupController dismiss];
}


- (IBAction)becomeMemberButtonClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(vipPressed:)]) {
        [self.delegate vipPressed:sender];
    }
    
    [self dismissViewControllerAnimated:NO completion:nil];
}
@end
