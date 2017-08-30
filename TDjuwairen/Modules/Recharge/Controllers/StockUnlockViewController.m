//
//  StockUnlockViewController.m
//  TDjuwairen
//
//  Created by zdy on 2016/12/21.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "StockUnlockViewController.h"
#import "NetworkManager.h"
#import "LoginStateManager.h"
#import "NotificationDef.h"
#import "STPopup.h"
#import "UIImage+Color.h"

@interface StockUnlockViewController ()
@end

@implementation StockUnlockViewController


- (void)setUnlockModel:(StockUnlockModel *)unlockModel {
    _unlockModel = unlockModel;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 11, kScreenWidth-24, 20)];
    titleLabel.font = [UIFont systemFontOfSize:14.0f];
    titleLabel.textColor = TDTitleTextColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"解锁调研";
    [self.view addSubview:titleLabel];
    
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-11-30, 6, 30, 30)];
    [closeBtn setImage:[UIImage imageNamed:@"unlock_close.png"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closePressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    
    UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(12.0f, 42, kScreenWidth-24, 1)];
    sep.backgroundColor = TDSeparatorColor;
    [self.view addSubview:sep];
    
    // 股票名称
    UILabel *stockNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 55, kScreenWidth-24, 20)];
    stockNameLabel.font = [UIFont systemFontOfSize:15.0f];
    stockNameLabel.textColor = TDTitleTextColor;
    stockNameLabel.textAlignment = NSTextAlignmentCenter;
    stockNameLabel.text = unlockModel.sruveyTitle;
    [self.view addSubview:stockNameLabel];
    
    UIButton *key = [[UIButton alloc] initWithFrame:CGRectMake(12, 86, kScreenWidth-24, 30)];
    key.enabled = NO;
    key.titleLabel.font = [UIFont systemFontOfSize:24.0f];
    [key setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#FF6C00"] forState:UIControlStateNormal];
    [key setTitle:[NSString stringWithFormat:@"%ld", (long)unlockModel.unlockKeyNum] forState:UIControlStateNormal];
    [key setImage:[UIImage imageNamed:@"icon_key_small.png"] forState:UIControlStateDisabled];
    [self.view addSubview:key];
    
    CGFloat offx = (kScreenWidth - 145*2-6)/2;
    UIButton *memberBtn = [[UIButton alloc] initWithFrame:CGRectMake(offx, 123, 145, 36)];
    UIImage *image1 = [UIImage imageWithSize:CGSizeMake(145, 36) withColor:[UIColor hx_colorWithHexRGBAString:@"#FF6D00"]];
    [memberBtn setBackgroundImage:image1 forState:UIControlStateNormal];
    [memberBtn setBackgroundImage:image1 forState:UIControlStateHighlighted];
    memberBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [memberBtn setTitle:unlockModel.vipDesc forState:UIControlStateNormal];
    [memberBtn addTarget:self action:@selector(memberPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:memberBtn];
    
    UIButton *unlockBtn = [[UIButton alloc] initWithFrame:CGRectMake(offx+145+6, 123, 145, 36)];
    UIImage *image2 = [UIImage imageWithSize:CGSizeMake(145, 36) withColor:[UIColor hx_colorWithHexRGBAString:@"#3370E2"]];
    [unlockBtn setBackgroundImage:image2 forState:UIControlStateNormal];
    [unlockBtn setBackgroundImage:image2 forState:UIControlStateHighlighted];
    unlockBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.view addSubview:unlockBtn];
    
    // 账号余额
    UILabel *balanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 173, kScreenWidth-24, 14)];
    balanceLabel.font = [UIFont systemFontOfSize:12.0f];
    balanceLabel.textColor = TDLightGrayColor;
    balanceLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:balanceLabel];
    
    if (unlockModel.userKeyNum < unlockModel.unlockKeyNum) {
        // 用户余额不够
        [unlockBtn setTitle:@"立即充值" forState:UIControlStateNormal];
        [unlockBtn addTarget:self action:@selector(rechargePressed:) forControlEvents:UIControlEventTouchUpInside];
        
        balanceLabel.text =  @"余额不足";
    } else {
        [unlockBtn setTitle:@"立即解锁" forState:UIControlStateNormal];
        [unlockBtn addTarget:self action:@selector(unlockPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        balanceLabel.text =  [NSString stringWithFormat:@"账号余额 %ld",(long)unlockModel.userKeyNum];
    }
    
    self.contentSizeInPopup = CGSizeMake(kScreenWidth, 220);
}

- (void)unlockPressed:(id)sender {
    [self.popupController dismissWithCompletion:^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(unlockWithSurveyId:withSurveyType:)]) {
            [self.delegate unlockWithSurveyId:self.unlockModel.sruveyId withSurveyType:self.unlockModel.sruveyType];
        }
    }];
}

- (void)rechargePressed:(id)sender {
    [self.popupController dismissWithCompletion:^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(rechargePressed:)]) {
            [self.delegate rechargePressed:sender];
        }
    }];
}

- (IBAction)closePressed:(id)sender {
    [self.popupController dismiss];
}


- (IBAction)memberPressed:(UIButton *)sender {
    [self.popupController dismissWithCompletion:^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(vipPressed:)]) {
            [self.delegate vipPressed:sender];
        }
    }];
}
@end
