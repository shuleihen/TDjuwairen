//
//  MBProgressHUD+Custom.h
//  TDjuwairen
//
//  Created by zdy on 2016/12/9.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Custom)
+ (MBProgressHUD *)showHUDAddedTo:(UIView *)view message:(NSString *)message;
@end
