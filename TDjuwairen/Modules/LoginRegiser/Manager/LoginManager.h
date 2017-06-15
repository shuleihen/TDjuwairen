//
//  LoginManager.h
//  TDjuwairen
//
//  Created by zdy on 2017/1/21.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginManager : NSObject
+ (void)getAuthKey;
+ (bool)checkLogin;
+ (void)multiLoginError;
@end
