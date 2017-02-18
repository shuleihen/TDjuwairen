//
//  YXSecurityCodeButton.m
//  RmbWithdraw
//
//  Created by zdy on 16/8/31.
//  Copyright © 2016年 lianlian. All rights reserved.
//

#import "YXSecurityCodeButton.h"
#import "HexColors.h"
#import "NetworkManager.h"
#import "MBProgressHUD.h"
#import "NSString+Util.h"

@interface YXSecurityCodeButton ()
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation YXSecurityCodeButton

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    
    if (enabled) {
        HXColor *color = [HXColor hx_colorWithHexRGBAString:@"#3371E2"];
        [self setTitleColor:color forState:UIControlStateNormal];
        [self setTitleColor:color forState:UIControlStateHighlighted];
    } else {
        HXColor *color = [HXColor hx_colorWithHexRGBAString:@"#999999"];
        [self setTitleColor:color forState:UIControlStateNormal];
        [self setTitleColor:color forState:UIControlStateHighlighted];
    }
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setup];
}

- (void)setup {
    if (!self.remainTime) {
        self.remainTime = 60;
    }
    
    if (!self.normalTitle) {
        self.normalTitle = @"| 发送验证码";
    }
    
    if (!self.formatTitle) {
        self.formatTitle = @"重新发送(%ds)";
    }
    
    self.time = self.remainTime;
    
    self.enabled = YES;
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
    PhoneCodeType type = [self.delegate codeType];
    
    phone = [phone stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    
    if (!phone.length) {
        [self reset];
        
        NSError *error = [NSError errorWithDomain:@"YXSecrityCodeButton" code:0 userInfo:@{NSLocalizedDescriptionKey:@"手机号不能为空"}];
        [self showErrorTip:error];
        return;
    }
    
    if (![phone isValidateMobile]) {
        [self reset];
        
        NSError *error = [NSError errorWithDomain:@"YXSecrityCodeButton" code:0 userInfo:@{NSLocalizedDescriptionKey:@"手机号格式错误"}];
        [self showErrorTip:error];
        return;
    }
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary *para = @{@"phone": phone,@"type":@(type)};
    [manager POST:API_LoginGetPhoneCode parameters:para completion:^(id data, NSError *error){
        if (!error) {
           
            self.msg_unique_id = data[@"msg_unique_id"];
            NSInteger status = [data[@"send_status"] integerValue];
            
            //0表示成功，1表示超过当日发送上线，2表示1分钟内只能发送一次
            if (status == 0) {
                
            } else if (status == 1) {
                [self reset];
                NSError *error = [NSError errorWithDomain:@"YXSecrityCodeButton" code:status userInfo:@{NSLocalizedDescriptionKey: @"超过当日发送上线"}];
                [self showErrorTip:error];
            } else if (status == 2) {
                [self reset];
                NSError *error = [NSError errorWithDomain:@"YXSecrityCodeButton" code:status userInfo:@{NSLocalizedDescriptionKey: @"1分钟内只能发送一次"}];
                [self showErrorTip:error];
            } else {
                [self reset];
                NSError *error = [NSError errorWithDomain:@"YXSecrityCodeButton" code:status userInfo:@{NSLocalizedDescriptionKey: @"获取验证码失败"}];
                [self showErrorTip:error];
            }
            
        } else {
            [self reset];
            [self showErrorTip:error];
        }
    }];
}

- (void)handStart {
    [self click:self];
}

- (void)showErrorTip:(NSError *)error {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = error.localizedDescription;
    [hud hide:YES afterDelay:0.6];
}
@end
