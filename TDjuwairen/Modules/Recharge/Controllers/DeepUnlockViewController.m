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

@interface DeepUnlockViewController ()

@end

@implementation DeepUnlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.contentSizeInPopup = CGSizeMake(kScreenWidth, 185);
}

- (void)setDeepModel:(SurveyDeepModel *)deepModel {
    _deepModel = deepModel;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 11, kScreenWidth-24, 20)];
    titleLabel.font = [UIFont systemFontOfSize:14.0f];
    titleLabel.textColor = TDTitleTextColor;
    titleLabel.text = @"解锁深度调研";
    [self.view addSubview:titleLabel];
    
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-24-30, 6, 30, 30)];
    [closeBtn setImage:[UIImage imageNamed:@"unlock_close.png"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closePressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(12.0f, 42, kScreenWidth-24, 1)];
    sep.backgroundColor = TDSeparatorColor;
    [self.view addSubview:sep];
    
    if (deepModel.deepPayType == kDeepPayFreeForMember) {
        // 会员免费，普通用户需要支付
        if (US.userLevel == kUserLevelNormal) {
            UIButton *key = [[UIButton alloc] initWithFrame:CGRectMake(12, 42+19, kScreenWidth-24, 30)];
            key.enabled = NO;
            key.titleLabel.font = [UIFont systemFontOfSize:24.0f];
            [key setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#FF6C00"] forState:UIControlStateNormal];
            [key setTitle:[NSString stringWithFormat:@"%ld", (long)deepModel.unlockKeyNum] forState:UIControlStateNormal];
            [key setImage:[UIImage imageNamed:@"icon_key_small.png"] forState:UIControlStateNormal];
            [self.view addSubview:key];

            CGFloat offx = (kScreenWidth - 195*2-6)/2;
            UIButton *memberBtn = [[UIButton alloc] initWithFrame:CGRectMake(offx, 98, 195, 36)];
            UIImage *image1 = [UIImage imageWithSize:CGSizeMake(195, 36) withColor:[UIColor hx_colorWithHexRGBAString:@"#FF6D00"]];
            [memberBtn setBackgroundImage:image1 forState:UIControlStateNormal];
            [memberBtn setBackgroundImage:image1 forState:UIControlStateHighlighted];
            memberBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
            [memberBtn setTitle:@"198成为会员" forState:UIControlStateNormal];
            [memberBtn addTarget:self action:@selector(memberPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            UIButton *unlockBtn = [[UIButton alloc] initWithFrame:CGRectMake(offx+195+6, 98, 195, 36)];
            UIImage *image2 = [UIImage imageWithSize:CGSizeMake(195, 36) withColor:[UIColor hx_colorWithHexRGBAString:@"#3370E2"]];
            [unlockBtn setBackgroundImage:image2 forState:UIControlStateNormal];
            [unlockBtn setBackgroundImage:image2 forState:UIControlStateHighlighted];
            unlockBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
            [unlockBtn setTitle:@"立即解锁" forState:UIControlStateNormal];
            [unlockBtn addTarget:self action:@selector(unlockPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            // 账号余额
            UILabel *balanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 198, kScreenWidth-24, 20)];
            balanceLabel.font = [UIFont systemFontOfSize:12.0f];
            balanceLabel.textColor = TDLightGrayColor;
            balanceLabel.text = @"账户余额";
            [self.view addSubview:titleLabel];
            
        } else if (US.userLevel == kUserLevelGold){
            
        }
    }
}

- (void)closePressed:(id)sender {
    
}

- (void)memberPressed:(id)sender {
    
}

- (void)unlockPressed:(id)sender {
    
}
@end
