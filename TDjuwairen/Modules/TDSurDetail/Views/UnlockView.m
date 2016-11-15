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

@implementation UnlockView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        UIdaynightModel *daynightModel = [UIdaynightModel sharedInstance];
        
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
        self.backView.backgroundColor = [UIColor blackColor];
        self.backView.alpha = 0.5;
        [self addSubview:self.backView];
        
        self.showView = [[UIView alloc] init];
        self.showView.backgroundColor = daynightModel.navigationColor;
        [self addSubview:self.showView];
        
        [self.showView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).with.offset(150);
            make.left.equalTo(self).with.offset(50);
            make.right.equalTo(self).with.offset(-50);
            make.height.mas_equalTo(200);
        }];
        
        UIButton *close = [[UIButton alloc] init];
        [close setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [self addSubview:close];
        [close mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.showView.mas_bottom).with.offset(30);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(40);
        }];
        [close addTarget:self action:@selector(closeUnlockView:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)closeUnlockView:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(closeUnlockView:)]) {
        [self.delegate closeUnlockView:sender];
    }
}

@end
