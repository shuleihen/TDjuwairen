//
//  UnlockVipBtn.m
//  TDjuwairen
//
//  Created by 团大 on 2016/11/16.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "UnlockVipBtn.h"
#import "HexColors.h"
#import "Masonry.h"

@implementation UnlockVipBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        UILabel *VIPLab = [[UILabel alloc] init];
        VIPLab.text = @"VIP";
        VIPLab.textColor = [HXColor hx_colorWithHexRGBAString:@"#F2BA2C"];
        VIPLab.textAlignment = NSTextAlignmentCenter;
        VIPLab.font = [UIFont systemFontOfSize:18];
        
        UILabel *titLabl = [[UILabel alloc] init];
        titLabl.text = @"解锁所有公司调研";
        titLabl.textColor = [HXColor hx_colorWithHexRGBAString:@"#F2BA2C"];
        titLabl.font = [UIFont systemFontOfSize:11];
        titLabl.textAlignment = NSTextAlignmentCenter;
        
        UIImageView *jiage = [[UIImageView alloc] init];
        jiage.image = [UIImage imageNamed:@"icon_jiage"];
        jiage.contentMode = UIViewContentModeScaleAspectFit;
        
        self.jiageLab = [[UILabel alloc] init];
        self.jiageLab.textColor = [HXColor hx_colorWithHexRGBAString:@"#999999"];
        
        [self addSubview:VIPLab];
        [self addSubview:titLabl];
        [self addSubview:jiage];
        [self addSubview:self.jiageLab];
        
        [VIPLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).with.offset(5);
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(20);
        }];
        
        [titLabl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(VIPLab.mas_bottom).with.offset(5);
            make.width.mas_equalTo(self.mas_width);
            make.height.mas_equalTo(15);
        }];
        
        [jiage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titLabl.mas_bottom).with.offset(5);
            make.left.equalTo(self.mas_centerX).with.offset((frame.size.width-65)/2);
            make.width.mas_equalTo(15);
            make.height.mas_equalTo(15);
        }];
        
        [self.jiageLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titLabl.mas_bottom).with.offset(5);
            make.left.equalTo(jiage.mas_right).with.offset(0);
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(15);
        }];
    }
    return self;
}

@end
