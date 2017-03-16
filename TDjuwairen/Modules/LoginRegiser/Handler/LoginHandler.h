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
@end
