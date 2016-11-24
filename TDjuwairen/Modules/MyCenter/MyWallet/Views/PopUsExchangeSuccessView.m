//
//  PopUsExchangeSuccessView.m
//  TDjuwairen
//
//  Created by 团大 on 2016/11/24.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "PopUsExchangeSuccessView.h"

#import "Masonry.h"
#import "HexColors.h"
#import "UIImageView+WebCache.h"

@implementation PopUsExchangeSuccessView

- (instancetype)initWithFrame:(CGRect)frame andWithModel:(ExchangeModel *)model
{
    if (self = [super initWithFrame:frame]) {
        
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
        self.backView.backgroundColor = [UIColor blackColor];
        self.backView.alpha = 0.5;
        
        self.duihuanImg = [[UIImageView alloc] init];
        self.duihuanImg.contentMode = UIViewContentModeScaleAspectFit;
        self.duihuanImg.userInteractionEnabled = YES;
        self.duihuanImg.image = [UIImage imageNamed:@"bg_duihuanchenggong"];
        
        self.prizeImg = [[UIImageView alloc] init];
        self.prizeImg.contentMode = UIViewContentModeScaleAspectFit;
        [self.prizeImg sd_setImageWithURL:[NSURL URLWithString:model.prize_app_img]];
        
        self.prizeLab = [[UILabel alloc] init];
        self.prizeLab.font = [UIFont systemFontOfSize:16];
        self.prizeLab.textColor = [HXColor hx_colorWithHexRGBAString:@"FFFFFF"];
        self.prizeLab.textAlignment = NSTextAlignmentCenter;
        self.prizeLab.text = [NSString stringWithFormat:@"成功领取%@",model.prize_name];
        
        self.goAwardBtn = [[UIButton alloc] init];
        [self.goAwardBtn addTarget:self action:@selector(clickClose:) forControlEvents:UIControlEventTouchUpInside];
        
        self.closeBtn = [[UIButton alloc] init];
        [self.closeBtn setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [self.closeBtn addTarget:self action:@selector(clickClose:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.backView];
        [self addSubview:self.duihuanImg];
        [self.duihuanImg addSubview:self.goAwardBtn];
        [self.duihuanImg addSubview:self.prizeImg];
        [self.duihuanImg addSubview:self.prizeLab];
        [self addSubview:self.closeBtn];
        
        [self.duihuanImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.centerX.equalTo(self);
            make.height.mas_equalTo((kScreenHeight-64)/3*2);
        }];
        
        [self.goAwardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self.duihuanImg).with.offset(-10);
            make.width.mas_equalTo(kScreenWidth/3);
            make.height.mas_equalTo(kScreenWidth/10);
        }];
        
        [self.prizeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self.goAwardBtn.mas_top).with.offset(-10);
            make.width.mas_equalTo(kScreenWidth/2);
            make.height.mas_equalTo(20);
        }];
        
        [self.prizeImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self.prizeLab.mas_top).with.offset(-15);
            make.width.mas_equalTo(kScreenWidth/5);
            make.height.mas_equalTo(kScreenWidth/5);
        }];
        
        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.duihuanImg.mas_bottom).with.offset(30);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(30);
        }];
        
    }
    return self;
}

- (void)clickClose:(UIButton *)sender{
    
}

@end
