//
//  LoginHandler.m
//  TDjuwairen
//
//  Created by zdy on 2017/1/21.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "LoginHandler.h"
#import "NetworkManager.h"
#import "LoginStateManager.h"
#import "Base64.h"
#import "UIDevice+Identifier.h"
#import <CloudPushSDK/CloudPushSDK.h>
#import "CocoaLumberjack.h"
#import "PlistFileDef.h"

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

+ (void)saveUserInfoData:(NSDictionary *)data {
    US.userId = data[@"user_id"];
    US.userName = data[@"user_name"];
    US.nickName = data[@"user_nickname"];
    US.headImage = data[@"userinfo_facesmall"];
    US.userPhone = data[@"userinfo_phone"];
    US.company = data[@"userinfo_company"];
    US.post = data[@"userinfo_occupation"];
    US.personal = data[@"userinfo_info"];
    US.sex = [data[@"user_sex"] integerValue];
    US.userLevel = [data[@"user_level"] integerValue];
}

+ (void)saveLoginAccountId:(NSString *)account password:(NSString *)password {
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    [accountDefaults setObject:@"normal" forKey:PLLoginType];
    [accountDefaults setObject:account forKey:@"account"];
    [accountDefaults setObject:password forKey:@"password"];
    [accountDefaults synchronize];
}

+ (void)saveFastLoginWithPhone:(NSString *)phone {
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    [accountDefaults setObject:@"fast" forKey:PLLoginType];
    [accountDefaults setObject:phone forKey:@"fast_phone"];
    [accountDefaults synchronize];
}

+ (void)saveThirdType:(NSString *)typeString unionid:(NSString *)unionid nickName:(NSString *)nickName avatar:(NSString *)avatar {
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    [accountDefaults setObject:typeString forKey:PLLoginType];
    [accountDefaults setObject:unionid forKey:@"third_userId"];
    [accountDefaults setObject:nickName forKey:@"third_nickName"];
    [accountDefaults setObject:avatar forKey:@"third_avatar"];
    [accountDefaults synchronize];
}

+ (void)checkOpenRemotePush {

    if ([[UIApplication sharedApplication] isRegisteredForRemoteNotifications]) {
        BOOL isClosePush = [[NSUserDefaults standardUserDefaults] boolForKey:@"isClosePush"];
        
        if (US.isLogIn && !isClosePush) {
            [CloudPushSDK bindAccount:US.userId withCallback:^(CloudPushCallbackResult *res){
                DDLogInfo(@"CloudPushSDK BindAccount =%@",res.success?@"成功":@"失败");
            }];
        }
    }
}


+ (void)openRemotePush {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isClosePush"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    if (US.isLogIn) {
        [CloudPushSDK bindAccount:US.userId withCallback:^(CloudPushCallbackResult *res){
            DDLogInfo(@"CloudPushSDK BindAccount =%@",res.success?@"成功":@"失败");
        }];
    }
}

+ (void)closeRemotePush {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isClosePush"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    
    [CloudPushSDK unbindAccount:^(CloudPushCallbackResult *res){
        DDLogInfo(@"CloudPushSDK unBindAccount =%@",res.success?@"成功":@"失败");
    }];
}

/// 打开响铃
+ (void)openRemoteBell {

    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kRemoteBell];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/// 关闭响铃
+ (void)closeRemoteBell {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kRemoteBell];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

/// 打开震动
+ (void)openRemoteShake {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kRemoteShake];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/// 关闭震动
+ (void)closeRemoteShake {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kRemoteShake];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


/// 打开自选股的调研通知
+ (void)openRemotePersionStock {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kRemotePersionStock];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/// 关闭自选股的调研通知
+ (void)closeRemotePersionStock {

    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kRemotePersionStock];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


/// 打开关注板块调研通知
+ (void)openRemoteAttentPlateSurvey {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kRemoteAttentPlateSurvey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
/// 关闭关注板块调研通知
+ (void)closeRemoteAttentPlateSurvey {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kRemoteAttentPlateSurvey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


/// 打开调研报告的提问被回答通知
+ (void)openRemoteSurveyReportAnswer {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kRemoteSurveyAnswer];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
/// 关闭调研报告的提问被回答通知
+ (void)closeRemoteSurveyReportAnswer {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kRemoteSurveyAnswer];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/// 打开评分模块的评论与回复通知
+ (void)openRemoteScoreModule {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kRemoteScoreModule];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
/// 关闭评分模块的评论与回复通知
+ (void)closeRemoteScoreModule {

    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kRemoteScoreModule];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

/// 打开直播－评论、回复通知
+ (void)openRemoteAliveCommon {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kRemoteAliveCommon];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
/// 关闭直播－评论、回复通知
+ (void)closeRemoteAliveCommon {
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kRemoteAliveCommon];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


/// 打开直播－点赞通知
+ (void)openRemoteAliveDianZan {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kRemoteAliveDianZan];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
/// 关闭直播－点赞通知
+ (void)closeRemoteAliveDianZan {

    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kRemoteAliveDianZan];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


/// 打开直播－转发通知
+ (void)openRemoteAliveForwarding {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kRemoteAliveForwarding];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
/// 关闭直播－转发通知
+ (void)closeRemoteAliveForwarding {

    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kRemoteAliveForwarding];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


/// 打开关注的人动态通知
+ (void)openRemoteAttentionPersionTrends {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kRemoteAttentionPersionTrends];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
/// 关闭关注的人动态通知
+ (void)closeRemoteAttentionPersionTrends {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kRemoteAttentionPersionTrends];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


/// 打开新粉丝通知
+ (void)openRemoteNewFans {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kRemoteNewFans];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
/// 关闭新粉丝通知
+ (void)closeRemoteNewFans {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kRemoteNewFans];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
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

    NSString *auth = [[NSUserDefaults standardUserDefaults] stringForKey:PLLoginEncryptAuthKey];
    NSString *string = [NSString stringWithFormat:@"%@%@",password,auth];
    
    NSString *encrypt = [string base64EncodedString];
    return encrypt;
}
@end
