//
//  LoginHandler.m
//  TDjuwairen
//
//  Created by zdy on 2017/1/21.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "LoginHandler.h"
#import "BPush.h"
#import "NetworkManager.h"
#import "LoginState.h"

@implementation LoginHandler
+ (void)saveLoginSuccessedData:(NSDictionary *)data {
    US.userId = data[@"user_id"];
    US.userName = data[@"user_name"];
    US.nickName = data[@"user_nickname"];
    US.headImage = data[@"userinfo_facesmall"];
    US.userPhone = data[@"userinfo_phone"];
    US.company = data[@"userinfo_company"];
    US.post = data[@"userinfo_occupation"];
    US.personal = data[@"userinfo_info"];
}

+ (void)saveLoginAccountId:(NSString *)account password:(NSString *)password {
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    [accountDefaults setValue:@"normal" forKey:@"loginStyle"];
    [accountDefaults setValue:account forKey:@"account"];
    [accountDefaults setValue:password forKey:@"password"];
    [accountDefaults synchronize];
}

+ (void)saveFastLoginWithPhone:(NSString *)phone {
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    [accountDefaults setValue:@"fast" forKey:@"loginStyle"];
    [accountDefaults setValue:phone forKey:@"fast_phone"];
    [accountDefaults synchronize];
}

+ (void)saveThirdType:(NSString *)typeString unionid:(NSString *)unionid nickName:(NSString *)nickName avatar:(NSString *)avatar {
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    [accountDefaults setValue:typeString forKey:@"loginStyle"];
    [accountDefaults setValue:unionid forKey:@"third_userId"];
    [accountDefaults setValue:unionid forKey:@"third_nickName"];
    [accountDefaults setValue:unionid forKey:@"third_avatar"];
    [accountDefaults synchronize];
}

+ (BOOL)checkOpenRemotePush {
    //判断是否开启推送
    UIApplication *app = [UIApplication sharedApplication];
    if ([app isRegisteredForRemoteNotifications]  == YES) {
        [self sendRemotePush];
        return YES;
    }
    
    return NO;
}

+ (void)sendRemotePush {
    NSString *channel_id = [BPush getChannelId];
    NSString *url = @"index.php/Login/saveUserChannelID";
    
    NetworkManager *manager = [[NetworkManager alloc]initWithBaseUrl:API_HOST];
    NSDictionary *para = @{@"user_id": US.userId,
                           @"type": @"1",
                           @"channel_id": channel_id};
    [manager POST:url parameters:para completion:^(id data, NSError *error) {
        //绑定指定推送的时候打开回复提醒
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        [userdefault setValue:@"YES" forKey:@"isReply"];
        [userdefault synchronize];
    }];
}
@end
