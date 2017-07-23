//
//  DeepUnlockViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/7/21.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "DeepUnlockViewController.h"
#import "STPopup.h"
#import "LoginState.h"
#import "UIImage+Color.h"
#import "SurveyDeepModel.h"

@interface DeepUnlockViewController ()

@end

@implementation DeepUnlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setUnlockModel:(StockUnlockModel *)unlockModel {
    _unlockModel = unlockModel;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 11, kScreenWidth-24, 20)];
    titleLabel.font = [UIFont systemFontOfSize:14.0f];
    titleLabel.textColor = TDTitleTextColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"解锁深度调研";
    [self.view addSubview:titleLabel];
    
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-11-30, 6, 30, 30)];
    [closeBtn setImage:[UIImage imageNamed:@"unlock_close.png"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closePressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    
    UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(12.0f, 42, kScreenWidth-24, 1)];
    sep.backgroundColor = TDSeparatorColor;
    [self.view addSubview:sep];
    
    CGFloat contentHeight = 0;
    
    if (unlockModel.deepPayType == kDeepPayFreeForMember) {
        // 解锁A，会员免费，普通用户需要支付
        if (US.userLevel == kUserLevelNormal) {
            UIButton *key = [[UIButton alloc] initWithFrame:CGRectMake(12, 60, kScreenWidth-24, 30)];
            key.enabled = NO;
            key.titleLabel.font = [UIFont systemFontOfSize:24.0f];
            [key setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#FF6C00"] forState:UIControlStateNormal];
            [key setTitle:[NSString stringWithFormat:@"%ld", (long)unlockModel.unlockKeyNum] forState:UIControlStateNormal];
            [key setImage:[UIImage imageNamed:@"icon_key_small.png"] forState:UIControlStateNormal];
            [self.view addSubview:key];

            CGFloat offx = (kScreenWidth - 145*2-6)/2;
            UIButton *memberBtn = [[UIButton alloc] initWithFrame:CGRectMake(offx, 98, 145, 36)];
            UIImage *image1 = [UIImage imageWithSize:CGSizeMake(145, 36) withColor:[UIColor hx_colorWithHexRGBAString:@"#FF6D00"]];
            [memberBtn setBackgroundImage:image1 forState:UIControlStateNormal];
            [memberBtn setBackgroundImage:image1 forState:UIControlStateHighlighted];
            memberBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
            [memberBtn setTitle:unlockModel.vipDesc forState:UIControlStateNormal];
            [memberBtn addTarget:self action:@selector(memberPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:memberBtn];
            
            UIButton *unlockBtn = [[UIButton alloc] initWithFrame:CGRectMake(offx+145+6, 98, 145, 36)];
            UIImage *image2 = [UIImage imageWithSize:CGSizeMake(145, 36) withColor:[UIColor hx_colorWithHexRGBAString:@"#3370E2"]];
            [unlockBtn setBackgroundImage:image2 forState:UIControlStateNormal];
            [unlockBtn setBackgroundImage:image2 forState:UIControlStateHighlighted];
            unlockBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
            [self.view addSubview:unlockBtn];
            
            // 账号余额
            UILabel *balanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 148, kScreenWidth-24, 20)];
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
            
            if (unlockModel.deepPayTip.length) {
                // 解锁提示
                UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 176, kScreenWidth-24, 20)];
                tipLabel.font = [UIFont systemFontOfSize:12.0f];
                tipLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#FF6D00"];
                tipLabel.text = unlockModel.deepPayTip;
                tipLabel.textAlignment = NSTextAlignmentCenter;
                [self.view addSubview:tipLabel];
                
                contentHeight = CGRectGetMaxY(tipLabel.frame) + 25;
            } else {
                contentHeight = CGRectGetMaxY(balanceLabel.frame) + 25;
            }
            
        } else if (US.userLevel == kUserLevelGold){
            // 解锁A，黄金会员，无需解锁
        }
    } else if (unlockModel.deepPayType == kDeepPayJustForMember) {
        // 解锁B，仅黄金会员可以看
        if (US.userLevel == kUserLevelNormal) {
            // 普通会员
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_goldhuiyuan"]];
            imageView.frame = CGRectMake((kScreenWidth-34)/2, 56, 34, 28);
            [self.view addSubview:imageView];
            
            UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 84, kScreenWidth-24, 20)];
            tipLabel.font = [UIFont systemFontOfSize:14.0f];
            tipLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#999999"];
            tipLabel.text = unlockModel.deepPayTip;
            tipLabel.textAlignment = NSTextAlignmentCenter;
            [self.view addSubview:tipLabel];
            
            UIButton *memberBtn = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth-145)/2, 125, 145, 36)];
            UIImage *image1 = [UIImage imageWithSize:CGSizeMake(145, 36) withColor:[UIColor hx_colorWithHexRGBAString:@"#FF6D00"]];
            [memberBtn setBackgroundImage:image1 forState:UIControlStateNormal];
            [memberBtn setBackgroundImage:image1 forState:UIControlStateHighlighted];
            memberBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
            [memberBtn setTitle:unlockModel.vipDesc forState:UIControlStateNormal];
            [memberBtn addTarget:self action:@selector(memberPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:memberBtn];
            
            contentHeight = CGRectGetMaxY(memberBtn.frame) + 25;

        } else if (US.userLevel == kUserLevelGold){
            // 解锁B，黄金会员，无需解锁
        }
    } else if (unlockModel.deepPayType == kDeepPayForAll) {
        // 解锁C，都必须付费才能查看
        UIButton *key = [[UIButton alloc] initWithFrame:CGRectMake(12, 42+19, kScreenWidth-24, 30)];
        key.enabled = NO;
        key.titleLabel.font = [UIFont systemFontOfSize:24.0f];
        [key setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#FF6C00"] forState:UIControlStateNormal];
        [key setTitle:[NSString stringWithFormat:@"%ld", (long)unlockModel.unlockKeyNum] forState:UIControlStateNormal];
        [key setImage:[UIImage imageNamed:@"icon_key_small.png"] forState:UIControlStateNormal];
        [self.view addSubview:key];
        
        UIButton *unlockBtn = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth-145)/2, 98, 145, 36)];
        UIImage *image2 = [UIImage imageWithSize:CGSizeMake(145, 36) withColor:[UIColor hx_colorWithHexRGBAString:@"#3370E2"]];
        [unlockBtn setBackgroundImage:image2 forState:UIControlStateNormal];
        [unlockBtn setBackgroundImage:image2 forState:UIControlStateHighlighted];
        unlockBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [self.view addSubview:unlockBtn];
        
        // 账号余额
        UILabel *balanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 148, kScreenWidth-24, 20)];
        balanceLabel.font = [UIFont systemFontOfSize:12.0f];
        balanceLabel.textColor = TDLightGrayColor;
        balanceLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:titleLabel];
        
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
        
        contentHeight = CGRectGetMaxY(balanceLabel.frame) + 25;
    }
    
    self.contentSizeInPopup = CGSizeMake(kScreenWidth, MAX(contentHeight, 185));
}

- (void)closePressed:(id)sender {
    [self.popupController dismiss];
}

- (void)memberPressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(vipPressed:)]) {
        [self.delegate vipPressed:sender];
    }
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)unlockPressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(unlockDeepWithDeepId:)]) {
        [self.delegate unlockDeepWithDeepId:self.unlockModel.deepId];
    }
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)rechargePressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(rechargePressed:)]) {
        [self.delegate rechargePressed:sender];
    }
    
    [self dismissViewControllerAnimated:NO completion:nil];
}
@end
