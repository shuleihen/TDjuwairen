//
//  WelcomeView.m
//  TDjuwairen
//
//  Created by 团大 on 2016/12/1.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "WelcomeView.h"
#import "LoginState.h"

@implementation WelcomeView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.welHead = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-100)/2, 150, 100, 100)];
        self.welHead.layer.cornerRadius = 50;
        self.welHead.layer.masksToBounds = YES;
        self.welHead.alpha = 0.0;
        [self addSubview:self.welHead];
        
        self.welLab = [[UILabel alloc] initWithFrame:CGRectMake(0,250, kScreenWidth, 30)];
        self.welLab.text = @"欢迎回来";
        self.welLab.alpha = 0.0;
        self.welLab.textColor = [UIColor blackColor];
        self.welLab.font = [UIFont systemFontOfSize:20];
        self.welLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.welLab];
        
        CGFloat logoX = (kScreenWidth - kScreenWidth/3)/2;
        self.welcomeLogo = [[UIImageView alloc] initWithFrame:CGRectMake(logoX, kScreenHeight-100, kScreenWidth/3, 60)];
        self.welcomeLogo.image = [UIImage imageNamed:@"welcomeLogo"];
        self.welcomeLogo.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.welcomeLogo];
        
        [UIView animateWithDuration:1.0 animations:^{
            self.welHead.alpha = 1.0;
            [self.welHead setFrame:CGRectMake((kScreenWidth-100)/2, 100, 100, 100)];
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                self.welLab.alpha = 1.0;
            }];
        }];
    }
    return self;
}

@end
