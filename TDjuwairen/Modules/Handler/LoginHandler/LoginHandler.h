//
//  LoginHandler.h
//  TDjuwairen
//
//  Created by zdy on 2017/1/21.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginHandler : NSObject
+ (void)saveLoginSuccessedData:(NSDictionary *)data;
+ (void)saveLoginAccountId:(NSString *)account password:(NSString *)password;
+ (void)saveFastLoginWithPhone:(NSString *)phone;
+ (void)saveThirdType:(NSString *)typeString unionid:(NSString *)unionid nickName:(NSString *)nickName avatar:(NSString *)avatar;

+ (NSString *)machineInfoJsonString;
+ (NSString *)encryptWithPassword:(NSString *)password;

+ (void)checkOpenRemotePush;
+ (void)openRemotePush;
+ (void)closeRemotePush;


/// 打开响铃
+ (void)openRemoteBell;
/// 关闭响铃
+ (void)closeRemoteBell;

/// 打开震动
+ (void)openRemoteShake;
/// 关闭震动
+ (void)closeRemoteShake;


/// 打开自选股的调研通知
+ (void)openRemotePersionStock;
/// 关闭自选股的调研通知
+ (void)closeRemotePersionStock;

/// 打开关注板块调研通知
+ (void)openRemoteAttentPlateSurvey;
/// 关闭关注板块调研通知
+ (void)closeRemoteAttentPlateSurvey;

/// 打开调研报告的提问被回答通知
+ (void)openRemoteSurveyReportAnswer;
/// 关闭调研报告的提问被回答通知
+ (void)closeRemoteSurveyReportAnswer;

/// 打开评分模块的评论与回复通知
+ (void)openRemoteScoreModule;
/// 关闭评分模块的评论与回复通知
+ (void)closeRemoteScoreModule;

/// 打开直播－评论、回复通知
+ (void)openRemoteAliveCommon;
/// 关闭直播－评论、回复通知
+ (void)closeRemoteAliveCommon;

/// 打开直播－点赞通知
+ (void)openRemoteAliveDianZan;
/// 关闭直播－点赞通知
+ (void)closeRemoteAliveDianZan;

/// 打开直播－转发通知
+ (void)openRemoteAliveForwarding;
/// 关闭直播－转发通知
+ (void)closeRemoteAliveForwarding;

/// 打开关注的人动态通知
+ (void)openRemoteAttentionPersionTrends;
/// 关闭关注的人动态通知
+ (void)closeRemoteAttentionPersionTrends;

/// 打开新粉丝通知
+ (void)openRemoteNewFans;
/// 关闭新粉丝通知
+ (void)closeRemoteNewFans;


@end
