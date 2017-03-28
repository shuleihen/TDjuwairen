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
+ (void)getAuthKey {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NetworkManager *ma = [[NetworkManager alloc] init];
        
        [ma POST:API_GetAuthKey parameters:nil completion:^(id data, NSError *error){
            if (!error) {
                NSString *authKey = data[@"auth_key"];
                [[NSUserDefaults standardUserDefaults] setValue:authKey forKey:@"auth_key"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            } else {
                
            }
        }];
    
    });
}

+ (void)multiLoginError {
    
    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIAlertController*alert=[UIAlertController alertControllerWithTitle:@"" message:@"您的账户在其他端登录" preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        US.isLogIn=NO;
        US.userName=nil;
        US.headImage=nil;
        US.userId=nil;
        
        NSUserDefaults*Defaults=[NSUserDefaults standardUserDefaults];
        [Defaults setValue:@"" forKey:@"loginStyle"];
        [Defaults setValue:@"" forKey:@"account"];
        [Defaults setValue:@"" forKey:@"password"];
        [Defaults setValue:@"" forKey:@"openid"];
        [Defaults setValue:@"" forKey:@"unionid"];
        [Defaults setValue:@"" forKey:@"unique_str"];
        [Defaults synchronize];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginStateChangedNotification object:nil];
    }]];
//    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [root presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Relogin

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
    
    NSString *ecriptPwd = [LoginHandler encryptWithPassword:password];
    
    NetworkManager *ma = [[NetworkManager alloc] init];
    NSDictionary *paras = @{@"account": account,
                            @"password": ecriptPwd};
    
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
    
    /*
     暂时去掉重新登录欢迎页
    WelcomeView *welcomeView = [[WelcomeView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) withNickName:nickName avatart:avatar];
    
    [[UIApplication sharedApplication].keyWindow addSubview:welcomeView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [welcomeView removeFromSuperview];
    });
     */
}

+ (void)clearLoginStatus {
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    [accountDefaults removeObjectForKey:@"loginStyle"];
}
@end
