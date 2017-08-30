//
//  StockPoolUnlockViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/8/17.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "StockPoolUnlockViewController.h"
#import "UIImage+Color.h"
#import "STPopup.h"

@interface StockPoolUnlockViewController ()

@end

@implementation StockPoolUnlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setUnlockModel:(StockPoolUnlockModel *)unlockModel {
    _unlockModel = unlockModel;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 11, kScreenWidth-24, 20)];
    titleLabel.font = [UIFont systemFontOfSize:14.0f];
    titleLabel.textColor = TDTitleTextColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"订阅股票池";
    [self.view addSubview:titleLabel];
    
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-11-30, 6, 30, 30)];
    [closeBtn setImage:[UIImage imageNamed:@"unlock_close.png"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closePressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    
    UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(12.0f, 42, kScreenWidth-24, 1)];
    sep.backgroundColor = TDSeparatorColor;
    [self.view addSubview:sep];
    
    // 订阅提示
    UILabel *stockNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 62, kScreenWidth-24, 26)];
    stockNameLabel.font = [UIFont systemFontOfSize:24.0f];
    stockNameLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#FF6C00"];
    stockNameLabel.textAlignment = NSTextAlignmentCenter;
    stockNameLabel.text = unlockModel.poolSetTip;
    [self.view addSubview:stockNameLabel];
    
    CGFloat offy = 0;
    NSString *btnTitle = @"";
    SEL sel = nil;
    
    if (unlockModel.isHaveEnoughKey) {
        CGSize size = [unlockModel.poolSetDesc boundingRectWithSize:CGSizeMake(kScreenWidth-24, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f]} context:nil].size;
        
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 104, kScreenWidth-24, size.height+4)];
        tipLabel.font = [UIFont systemFontOfSize:12.0f];
        tipLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#666666"];
        tipLabel.text = unlockModel.poolSetDesc;
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.numberOfLines = 0;
        [self.view addSubview:tipLabel];
        
        offy = CGRectGetMaxY(tipLabel.frame) + 16;
        btnTitle = @"我要订阅";
        sel = @selector(unlockPressed:);
    } else {
        CGSize size = [unlockModel.poolSetDesc boundingRectWithSize:CGSizeMake(kScreenWidth-24, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f]} context:nil].size;
        
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 94, kScreenWidth-24, size.height+4)];
        tipLabel.font = [UIFont systemFontOfSize:12.0f];
        tipLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#666666"];
        tipLabel.text = unlockModel.poolSetDesc;
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.numberOfLines = 0;
        [self.view addSubview:tipLabel];
                
        UILabel *tipLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(12, 94+size.height+10, kScreenWidth-24, 14)];
        tipLabel1.font = [UIFont systemFontOfSize:12.0f];
        tipLabel1.textColor = [UIColor hx_colorWithHexRGBAString:@"#FF523B"];
        tipLabel1.text = @"钥匙数不足";
        tipLabel1.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:tipLabel1];
        
        offy = CGRectGetMaxY(tipLabel1.frame) + 10;
        btnTitle = @"我要充值";
        sel = @selector(rechargePressed:);
    }
    
    
    UIButton *memberBtn = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth-142)/2, offy, 142, 36)];
    UIImage *image1 = [UIImage imageWithSize:CGSizeMake(142, 36) withColor:[UIColor hx_colorWithHexRGBAString:@"#3370E2"]];
    [memberBtn setBackgroundImage:image1 forState:UIControlStateNormal];
    [memberBtn setBackgroundImage:image1 forState:UIControlStateHighlighted];
    memberBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [memberBtn setTitle:btnTitle forState:UIControlStateNormal];
    [memberBtn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:memberBtn];
    
    self.contentSizeInPopup = CGSizeMake(kScreenWidth, 210);
}

- (void)closePressed:(id)sender {
    [self.popupController dismiss];
}

- (void)unlockPressed:(id)sender {
    [self.popupController dismissWithCompletion:^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(unlockWithStockPoolMasterId:)]) {
            [self.delegate unlockWithStockPoolMasterId:self.unlockModel.masterId];
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
@end
