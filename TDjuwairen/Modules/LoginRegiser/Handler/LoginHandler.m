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
#import "Base64.h"
#import "UIDevice+Identifier.h"

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
    
    NSString *unique_str = data[@"user_appuidcode"];
    [[NSUserDefaults standardUserDefaults] setObject:unique_str forKey:@"unique_str"];
}

+ (void)saveLoginAccountId:(NSString *)account password:(NSString *)password {
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    [accountDefaults setObject:@"normal" forKey:@"loginStyle"];
    [accountDefaults setObject:account forKey:@"account"];
    [accountDefaults setObject:password forKey:@"password"];
    [accountDefaults synchronize];
}

+ (void)saveFastLoginWithPhone:(NSString *)phone {
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    [accountDefaults setObject:@"fast" forKey:@"loginStyle"];
    [accountDefaults setObject:phone forKey:@"fast_phone"];
    [accountDefaults synchronize];
}

+ (void)saveThirdType:(NSString *)typeString unionid:(NSString *)unionid nickName:(NSString *)nickName avatar:(NSString *)avatar {
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    [accountDefaults setObject:typeString forKey:@"loginStyle"];
    [accountDefaults setObject:unionid forKey:@"third_userId"];
    [accountDefaults setObject:nickName forKey:@"third_nickName"];
    [accountDefaults setObject:avatar forKey:@"third_avatar"];
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
        [userdefault setObject:@"YES" forKey:@"isReply"];
        [userdefault synchronize];
    }];
}

+ (NSString *)machineInfoJsonString {
    UIDevice *device = [UIDevice currentDevice];
    NSString *uuid = [device uniqueDeviceIdentifier];
    CGRect rect = [UIScreen mainScreen].bounds;
    NSString *screen = [NSString stringWithFormat:@"%.0f*%.0f", CGRectGetWidth(rect), CGRectGetHeight(rect)];
    
    NSDictionary *dict = @{@"machineid":   uuid,
                           @"screen":       screen,
                           @"manufacturer": @"Apple",
                           @"os_model":     device.model,
                           @"os_sdk":       device.systemVersion};
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:NULL];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+ (NSString *)encryptWithPassword:(NSString *)password {

    NSString *auth = [[NSUserDefaults standardUserDefaults] stringForKey:@"auth_key"];
    NSString *string = [NSString stringWithFormat:@"%@%@",password,auth];
    
    NSString *encrypt = [string base64EncodedString];
    return encrypt;
}
@end
