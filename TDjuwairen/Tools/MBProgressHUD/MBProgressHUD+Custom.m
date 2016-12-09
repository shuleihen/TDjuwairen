//
//  MBProgressHUD+Custom.m
//  TDjuwairen
//
//  Created by zdy on 2016/12/9.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "MBProgressHUD+Custom.h"
#import "HexColors.h"

@implementation MBProgressHUD (Custom)

+ (MBProgressHUD *)showHUDAddedTo:(UIView *)view message:(NSString *)message {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelFont = [UIFont systemFontOfSize:14.0f];
    hud.labelColor = [UIColor hx_colorWithHexRGBAString:@"#323232"];
    hud.labelText = message;
    [hud hide:YES afterDelay:0.4];
    return hud;
}

@end
