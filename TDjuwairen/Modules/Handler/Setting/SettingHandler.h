//
//  SettingHandler.h
//  TDjuwairen
//
//  Created by zdy on 2017/7/27.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingHandler : NSObject

// 推送响铃设置
+ (BOOL)isOpenRemoteBell;
+ (void)openRemoteBell;
+ (void)closeRemoteBell;

// 推送震动设置
+ (BOOL)isRemoteShake;
+ (void)openRemoteShake;
+ (void)closeRemoteShake;
@end
