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
        // 解锁A
        if (US.userLevel == kUserLevelNormal) {
            
        } else if (US.userLevel == kUserLevelGold){
            
        }
    }
}

- (void)closePressed:(id)sender {
    
}
@end
