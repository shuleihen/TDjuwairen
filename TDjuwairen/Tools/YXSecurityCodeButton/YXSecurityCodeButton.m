//
//  YXSecurityCodeButton.m
//  RmbWithdraw
//
//  Created by zdy on 16/8/31.
//  Copyright © 2016年 lianlian. All rights reserved.
//

#import "YXSecurityCodeButton.h"
#import "HexColors.h"
#import <SMS_SDK/SMSSDK.h>

@interface YXSecurityCodeButton ()
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation YXSecurityCodeButton

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    
    if (enabled) {
        HXColor *color = [HXColor hx_colorWithHexRGBAString:@"#09B1F3"];
        [self setTitleColor:color forState:UIControlStateNormal];
        [self setTitleColor:color forState:UIControlStateHighlighted];
    } else {
        HXColor *color = [HXColor hx_colorWithHexRGBAString:@"#999999"];
        [self setTitleColor:color forState:UIControlStateNormal];
        [self setTitleColor:color forState:UIControlStateHighlighted];
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    if (!self.remainTime) {
        self.remainTime = 60;
    }
    
    if (!self.normalTitle) {
        self.normalTitle = @"获取验证码";
    }
    
    if (!self.formatTitle) {
        self.formatTitle = @"%d重新发送";
    }
    
    self.time = self.remainTime;
    [self setTitle:self.normalTitle forState:UIControlStateNormal];
    [self addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)click:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(canRequest)]) {
        if (![self.delegate canRequest]) {
            return;
        }
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timing) userInfo:nil repeats:YES];
    self.enabled = NO;
    
    self.time = self.remainTime - 1;
    [self setTitle:[NSString stringWithFormat:self.formatTitle, self.time] forState:UIControlStateDisabled];
    
    [self getCode];
}


- (void)timing {
    if (self.time == 0) {
        // 停止计时器
        [self reset];
    }
    
    self.time --;
    [self setTitle:[NSString stringWithFormat:self.formatTitle, self.time] forState:UIControlStateDisabled];
    [self setTitle:[NSString stringWithFormat:self.formatTitle, self.time] forState:UIControlStateHighlighted];
}

- (void)reset {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    self.time = self.remainTime;
    self.enabled = YES;
    [self setTitle:self.normalTitle forState:UIControlStateNormal];
    [self setTitle:self.normalTitle forState:UIControlStateHighlighted];
}

- (void)getCode {
    NSString *phone = [self.delegate codeWithPhone];
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:phone zone:@"86" customIdentifier:nil result:^(NSError *error) {
        if (error) {
            [self reset];
        }
        
        [self.delegate codeCompletionWithResult:error];
    }];
}

- (void)handStart {
    [self click:self];
}
@end
