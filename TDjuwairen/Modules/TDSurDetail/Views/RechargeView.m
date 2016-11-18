//
//  RechargeView.m
//  TDjuwairen
//
//  Created by 团大 on 2016/11/16.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "RechargeView.h"
#import "KeysBtn.h"
#import "UnlockVipBtn.h"

#import "UIdaynightModel.h"
#import "Masonry.h"

@implementation RechargeView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        UIdaynightModel *daynightModel = [UIdaynightModel sharedInstance];
        
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        self.backView.backgroundColor = [UIColor blackColor];
        self.backView.alpha = 0.5;
        
        self.showView = [[UIView alloc] init];
        self.showView.layer.cornerRadius = 10;
        self.showView.backgroundColor = daynightModel.navigationColor;
        self.showView.clipsToBounds = YES;     //不超出范围
        
        UILabel *rechargeLabl = [[UILabel alloc] init];
        rechargeLabl.text = @"充值";
        rechargeLabl.textColor = daynightModel.textColor;
        rechargeLabl.textAlignment = NSTextAlignmentCenter;
        rechargeLabl.font = [UIFont systemFontOfSize:22];
        
        UIButton *close = [[UIButton alloc] init];
        [close setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [close addTarget:self action:@selector(closeRechargeView:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.backView];
        [self addSubview:self.showView];
        [self addSubview:rechargeLabl];
        [self addSubview:close];
        
        [self.showView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self);
            make.left.equalTo(self).with.offset(50);
            make.right.equalTo(self).with.offset(-50);
        }];
        
        [rechargeLabl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.showView);
            make.top.equalTo(self.showView).with.offset(15);
            make.width.mas_equalTo(self.showView.mas_width);
            make.height.mas_equalTo(30);
        }];
        
        [close mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.showView);
            make.top.equalTo(self.showView.mas_bottom).with.offset(30);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(30);
        }];
        
        NSArray *keynumArr = @[@"1",@"5",@"10",@"0"];
        NSArray *moneyArr = @[@"5",@"25",@"50",@"2999"];
        for (int i = 0; i < 4; i++) {
            
            if (i == 3) {
                UnlockVipBtn *vipBtn = [[UnlockVipBtn alloc] init];
                vipBtn.jiageLab.text = moneyArr[i];
                vipBtn.layer.borderWidth = 0.5;
                vipBtn.layer.borderColor = daynightModel.lineColor.CGColor;
                vipBtn.tag = i;
                [vipBtn addTarget:self action:@selector(clickRecharge:) forControlEvents:UIControlEventTouchUpInside];
                [self.showView addSubview:vipBtn];
                
                [vipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(rechargeLabl.mas_bottom).with.offset(15+i/2*75);
                    make.left.equalTo(self.showView).with.offset(i%2 * ((kScreenWidth-100)/2));
                    make.bottom.equalTo(self.showView).with.offset(-(1-i/2)*75);
                    make.right.equalTo(self.showView).with.offset(-(1-i%2)*((kScreenWidth-100)/2));
                    make.height.mas_equalTo(75);
                }];
                
                break;
            }
            KeysBtn *keyBtn = [[KeysBtn alloc] init];
            keyBtn.keyNum.text = keynumArr[i];
            keyBtn.jiageLab.text = moneyArr[i];
            keyBtn.layer.borderWidth = 0.5;
            keyBtn.layer.borderColor = daynightModel.lineColor.CGColor;
            keyBtn.tag = i;
            [keyBtn addTarget:self action:@selector(clickRecharge:) forControlEvents:UIControlEventTouchUpInside];
            [self.showView addSubview:keyBtn];
            
            [keyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(rechargeLabl.mas_bottom).with.offset(15+i/2*75);
                make.left.equalTo(self.showView).with.offset(i%2 * ((kScreenWidth-100)/2));
                make.bottom.equalTo(self.showView).with.offset(-(1-i/2)*75);
                make.right.equalTo(self.showView).with.offset(-(1-i%2)*((kScreenWidth-100)/2));
                make.height.mas_equalTo(75);
            }];
        }
        
    }
    return self;
}

- (void)clickRecharge:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(clickRecharge:)]) {
        [self.delegate clickRecharge:sender];
    }
}

- (void)closeRechargeView:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(closeRechargeView:)]) {
        [self.delegate closeRechargeView:sender];
    }
}

@end
