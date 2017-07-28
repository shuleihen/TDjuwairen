//
//  LoginManager.m
//  TDjuwairen
//
//  Created by zdy on 2017/1/21.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "LoginManager.h"
#import "LoginStateManager.h"
#import "NetworkManager.h"
#import "LoginHandler.h"
#import "NotificationDef.h"
#import "CocoaLumberjack.h"
#import "WelcomeView.h"
#import "PlistFileDef.h"
#import "NSString+Util.h"

@implementation LoginManager
+ (void)loginHandler {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NetworkManager *ma = [[NetworkManager alloc] init];
        NSString *uniqueStr = [[NSUserDefaults standardUserDefaults] stringForKey:PLLoginAccessToken];
        NSDictionary *dict = @{@"unique_str": uniqueStr?:@""};
        
        [ma POST:API_GetAuthKey parameters:dict completion:^(id data, NSError *error){
            if (!error) {
                // 保存加密钥匙key
                NSString *authKey = data[@"auth_key"];
                [[NSUserDefaults standardUserDefaults] setValue:authKey forKey:PLLoginEncryptAuthKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
                /*
                BOOL loginStatus = [data[@"login_status"] boolValue];
                if (loginStatus) {
                    // 已经登录
                    US.isLogIn = YES;
                    
                    [LoginHandler saveLoginSuccessedData:data];
                    [LoginHandler checkOpenRemotePush];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginStateChangedNotification object:nil];
                } else {
                    // 未登录
                    [LoginManager checkLogin];
                }
                 */
            } else {
//                [LoginManager checkLogin];
            }
            
            [LoginManager checkLogin];
        }];
    
    });
}

+ (void)multiLoginError {
    
    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIAlertController*alert=[UIAlertController alertControllerWithTitle:@"" message:@"您的账户在其他端登录" preferredStyle:UIAlertControllerStyleAlert];
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
        [self clearnLocalHistoryStock];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginStateChangedNotification object:nil];
    }]];

    [root presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Relogin


+ (BOOL)checkLogin {
    BOOL canRelogin = [LoginManager canRelogin];
    if (canRelogin) {
        [LoginManager doRelogin];
    }
    
    return YES;
}

+ (BOOL)canRelogin {
    NSString *loginType = [[NSUserDefaults standardUserDefaults] objectForKey:PLLoginType];
    if (loginType.length == 0) {
        return NO;
    }
    
    if ([loginType isEqualToString:@"normal"]) {
        NSString *account = [[NSUserDefaults standardUserDefaults] stringForKey:PLLoginAccount];
        NSString *password = [[NSUserDefaults standardUserDefaults] stringForKey:PLLoginPassword];
        
        if (account.length && password) {
            return YES;
        }
    } else if ([loginType isEqualToString:@"fast"]) {
        NSString *phone = [[NSUserDefaults standardUserDefaults] stringForKey:PLLoginPhone];
        if ([phone isValidateMobile]) {
            return YES;
        }
    } else if ([loginType isEqualToString:@"qq"] ||
               [loginType isEqualToString:@"weixin"]) {
        NSString *unionid = [[NSUserDefaults standardUserDefaults] objectForKey:PLLoginThirdUserId];
        NSString *nickName = [[NSUserDefaults standardUserDefaults] objectForKey:PLLoginThirdNickName];
        NSString *avatar = [[NSUserDefaults standardUserDefaults] objectForKey:PLLoginThirdAvatar];
        
        if (unionid.length &&
            nickName.length &&
            avatar.length) {
            return YES;
        }
    }
    
    return NO;
}

+ (void)doRelogin {
    NSString *loginType = [[NSUserDefaults standardUserDefaults] objectForKey:PLLoginType];
    
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
    NSString *unionid = [[NSUserDefaults standardUserDefaults] objectForKey:PLLoginThirdUserId];
    NSString *nickName = [[NSUserDefaults standardUserDefaults] objectForKey:PLLoginThirdNickName];
    NSString *avatar = [[NSUserDefaults standardUserDefaults] objectForKey:PLLoginThirdAvatar];
    
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



+ (void)clearnLocalHistoryStock {
    //    获取路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"localSearchStockHistory.plist"];
    NSFileManager *fileM = [NSFileManager defaultManager];
    //    判断文件是否存在，存在则删除
    if ([fileM fileExistsAtPath:filePath]) {
        [fileM removeItemAtPath:filePath error:nil];
    }
}

@end
