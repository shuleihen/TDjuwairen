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
@property (assign, nonatomic) NSInteger balanceKey;
@end

@implementation StockUnlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.contentSizeInPopup = CGSizeMake(210, 220);
    
    self.stockNameLabel.text = [NSString stringWithFormat:@"%@(%@)",self.stockName,self.stockCode];
    [self.keyNumberBtn setTitle:[NSString stringWithFormat:@"%ld",(long)self.needKey] forState:UIControlStateNormal];
    
    if (US.isLogIn) {
        NSDictionary *para = @{@"user_id":US.userId};
        NetworkManager *ma = [[NetworkManager alloc] init];
        [ma POST:API_QueryKeyNumber parameters:para completion:^(id data, NSError *error){
            if (!error) {
                long keyNumber = [data[@"keyNum"] longValue];
                self.balanceKey = keyNumber;
                [self setupDataWithKeyNumber:keyNumber];
            } else {
                //
                [self setupDataWithKeyNumber:0];
            }
        }];
    }
}

- (void)setupDataWithKeyNumber:(long)keyNumber {
    
    if (keyNumber >= self.needKey) {
        self.balanceLabel.text = [NSString stringWithFormat:@"账户余额  %ld",keyNumber];
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
    
    if (self.needKey > self.balanceKey) {
        UIAlertAction *done = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:nil];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"账户余额不足！" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:done];
        [self.popupController presentInViewController:alert completion:nil];
        return;
    }else {
    
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(unlockWithStockCode:)]) {
            [self.delegate unlockWithStockCode:self.stockCode];
        }
        
        [self dismissViewControllerAnimated:NO completion:nil];
    }
    
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
}
@end
