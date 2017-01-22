//
//  LoginManager.m
//  TDjuwairen
//
//  Created by zdy on 2017/1/21.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "LoginManager.h"
#import "LoginState.h"
#import "NetworkManager.h"
#import "LoginHandler.h"
#import "NotificationDef.h"
#import "CocoaLumberjack.h"
#import "WelcomeView.h"

@implementation LoginManager
+ (void)checkLogin {
    // normal、fast、qq、weixin
    NSString *loginType = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginStyle"];
    
    if (loginType.length) {
        [LoginManager showWelcomeWithNickName:@"" avatar:@""];
    }
    
    if ([loginType isEqualToString:@"normal"]) {
        [LoginManager normalLogin];
    } else if ([loginType isEqualToString:@"fast"]) {
        [LoginManager fastLogin];
    } else {
        [LoginManager thirdPartLogin:loginType];
    }
}

+ (void)normalLogin {
    NSString *account = [[NSUserDefaults standardUserDefaults] stringForKey:@"account"];
    NSString *password = [[NSUserDefaults standardUserDefaults] stringForKey:@"password"];
    
    if (!account.length || !password) {
        return;
    }
    
    NetworkManager *ma = [[NetworkManager alloc] init];
    NSDictionary *paras = @{@"account": account,
                            @"password": password};
    
    [ma POST:API_Login parameters:paras completion:^(id data, NSError *error){
        if (!error) {
            US.isLogIn = YES;
            
            [LoginHandler saveLoginSuccessedData:data];
            [LoginHandler checkOpenRemotePush];
            [LoginManager showWelcomeWithNickName:US.nickName avatar:US.headImage];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginStateChangedNotification object:nil];
        } else if (error.code == 300){
            // 密码不正确
            [LoginManager clearLoginStatus];
            DDLogError(@"Default login noraml type error= %@",error);
        } else {
            DDLogError(@"Default login noraml type error= %@",error);
        }
    }];
}

+ (void)fastLogin {
    NSString *phone = [[NSUserDefaults standardUserDefaults] stringForKey:@"fast_phone"];
    NSString *validate = @"tuandawangluokeji";
    
    if (!phone.length) {
        return;
    }
    
    void (^loginBlock)(NSString *) = ^(NSString *encryptString){
        NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
        NSDictionary *dic = @{@"user_phone": phone,
                              @"authenticationStr": validate,
                              @"encryptedStr": encryptString};
        
        [manager POST:API_LoginWithPhone parameters:dic completion:^(id data, NSError *error){
            if (!error) {
                if ([data[@"need_complete"] boolValue] == NO) {
                    US.isLogIn = YES;
                    
                    [LoginHandler saveLoginSuccessedData:data];
                    [LoginHandler checkOpenRemotePush];
                    [LoginManager showWelcomeWithNickName:US.nickName avatar:US.headImage];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginStateChangedNotification object:nil];
                } else {
                    DDLogError(@"Default login fast type last user info");
                }
            } else {
               DDLogError(@"Default login fast type error= %@",error);
            }
        }];
    
    };
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary *para = @{@"validatestring":validate};
    
    [manager POST:API_GetApiValidate parameters:para completion:^(id data, NSError *error){
        if (!error) {
            NSString *encryptedStr = data[@"str"];
            loginBlock(encryptedStr);
        } else {
           DDLogError(@"Default login fast type error= %@",error);
        }
    }];
}

+ (void)thirdPartLogin:(NSString *)type {
    NSString *unionid = [[NSUserDefaults standardUserDefaults] objectForKey:@"third_userId"];
    NSString *nickName = [[NSUserDefaults standardUserDefaults] objectForKey:@"third_nickName"];;
    NSString *avatar = [[NSUserDefaults standardUserDefaults] objectForKey:@"third_avatar"];;
    
    if (!unionid.length ||
        !nickName.length ||
        !avatar.length) {
        return;
    }
    
    NSString *url;
    if ([type isEqualToString:@"qq"]) {
        url = API_LoginWithQQ;
    } else if ([type isEqualToString:@"weixin"]) {
        url = API_LoginWithWeixin;
    } else {
        return;
    }
    
    NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
    NSDictionary *dic = @{@"unionid": unionid,
                          @"nickname" : nickName,
                          @"avatar_url": avatar};
    
    [manager POST:url parameters:dic completion:^(id data, NSError *error){
        
        if (!error) {
            if ([data[@"need_complete"] boolValue] == NO) {
                
                US.isLogIn = YES;
                
                [LoginHandler saveLoginSuccessedData:data];
                [LoginHandler checkOpenRemotePush];
                
                [LoginManager showWelcomeWithNickName:US.nickName avatar:US.headImage];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kLoginStateChangedNotification object:nil];
            } else {
                DDLogError(@"Default login third type last user info");
            }
        } else {
            DDLogError(@"Default login third type %@ error= %@",type,error);
        }
    }];
}

+ (void)showWelcomeWithNickName:(NSString *)nickName avatar:(NSString *)avatar {
    WelcomeView *welcomeView = [[WelcomeView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) withNickName:nickName avatart:avatar];
    
    [[UIApplication sharedApplication].keyWindow addSubview:welcomeView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [welcomeView removeFromSuperview];
    });
}

+ (void)clearLoginStatus {
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    [accountDefaults removeObjectForKey:@"loginStyle"];
}
@end
