//
//  UnlockView.m
//  TDjuwairen
//
//  Created by 团大 on 2016/11/15.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "UnlockView.h"

#import "UIdaynightModel.h"
#import "Masonry.h"
#import "HexColors.h"

@implementation UnlockView

- (instancetype)initWithFrame:(CGRect)frame andCompany_name:(NSString *)companyName
{
    if (self = [super initWithFrame:frame]) {
        
        UIdaynightModel *daynightModel = [UIdaynightModel sharedInstance];
        
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
        self.backView.backgroundColor = [UIColor blackColor];
        self.backView.alpha = 0.5;
        
        self.showView = [[UIView alloc] init];
        self.showView.layer.cornerRadius = 10;
        self.showView.backgroundColor = daynightModel.navigationColor;
        
        UILabel *titLab = [[UILabel alloc] init];
        titLab.text = @"解锁股票";
        titLab.textAlignment = NSTextAlignmentCenter;
        titLab.font = [UIFont systemFontOfSize:18];
        titLab.textColor = daynightModel.textColor;
        
        UILabel *nameLab = [[UILabel alloc] init];
        nameLab.text = companyName;
        nameLab.textAlignment = NSTextAlignmentCenter;
        nameLab.font = [UIFont systemFontOfSize:20];
        nameLab.textColor = daynightModel.textColor;
        
        UIImageView *lockImgView = [[UIImageView alloc] init];
        lockImgView.image = [UIImage imageNamed:@"key_yello"];
        lockImgView.contentMode = UIViewContentModeScaleAspectFit;
        
        UILabel *lockNum = [[UILabel alloc] init];
        lockNum.text = @"1";
        lockNum.textAlignment = NSTextAlignmentCenter;
        lockNum.font = [UIFont systemFontOfSize:30];
        lockNum.textColor = [HXColor hx_colorWithHexRGBAString:@"#F2BA2C"];
        
        self.balanceLab = [[UILabel alloc] init];
        self.balanceLab.font = [UIFont systemFontOfSize:15];
        self.balanceLab.textColor = daynightModel.titleColor;
        self.balanceLab.textAlignment = NSTextAlignmentCenter;
        
        UILabel *line = [[UILabel alloc] init];
        line.layer.borderWidth = 1.0;
        line.layer.borderColor = daynightModel.lineColor.CGColor;
        
        self.unlockBtn = [[UIButton alloc] init];
        [self.unlockBtn setBackgroundColor:[UIColor colorWithRed:33/255.0 green:107/255.0 blue:174/255.0 alpha:1.0]];
        self.unlockBtn.layer.cornerRadius = 5;
        [self.unlockBtn addTarget:self action:@selector(clickUnlockOrRecharge:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *close = [[UIButton alloc] init];
        [close setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [close addTarget:self action:@selector(closeUnlockView:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.backView];
        [self addSubview:self.showView];
        [self.showView addSubview:titLab];
        [self.showView addSubview:nameLab];
        [self.showView addSubview:lockImgView];
        [self.showView addSubview:lockNum];
        [self.showView addSubview:self.balanceLab];
        [self.showView addSubview:line];
        [self.showView addSubview:self.unlockBtn];
        [self addSubview:close];
        
        [self.showView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self);
            make.left.equalTo(self).with.offset(50);
            make.right.equalTo(self).with.offset(-50);
        }];
        
        [close mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.showView);
            make.top.equalTo(self.showView.mas_bottom).with.offset(30);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(30);
        }];
        
        [titLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.showView);
            make.top.equalTo(self.showView).with.offset(25);
            make.width.mas_equalTo(self.showView.mas_width);
            make.height.mas_equalTo(20);
        }];
        
        [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.showView);
            make.top.equalTo(titLab.mas_bottom).with.offset(15);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(30);
        }];
        
        [lockImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.showView).with.offset(-15);
            make.top.equalTo(nameLab.mas_bottom).with.offset(15);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(30);
        }];
        
        [lockNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(nameLab.mas_bottom).with.offset(15);
            make.left.equalTo(lockImgView.mas_right).with.offset(0);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(30);
        }];
        
        [self.balanceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.showView);
            make.top.equalTo(lockImgView.mas_bottom).with.offset(15);
            make.width.mas_equalTo(self.showView.mas_width);
            make.height.mas_equalTo(20);
        }];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.balanceLab.mas_bottom).with.offset(15);
            make.left.equalTo(self.showView).with.offset(40);
            make.right.equalTo(self.showView).with.offset(-40);
            make.height.mas_equalTo(1);
        }];
        
        [self.unlockBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.showView);
            make.top.equalTo(line.mas_bottom).with.offset(25);
            make.bottom.equalTo(self.showView.mas_bottom).with.offset(-30);
            make.width.mas_equalTo(85);
            make.height.mas_equalTo(35);
        }];
        
    }
    return self;
}

- (void)closeUnlockView:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(closeUnlockView:)]) {
        [self.delegate closeUnlockView:sender];
    }
}

- (void)clickUnlockOrRecharge:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(clickUnlockOrRecharge:)]) {
        [self.delegate clickUnlockOrRecharge:sender];
    }
}

@end
