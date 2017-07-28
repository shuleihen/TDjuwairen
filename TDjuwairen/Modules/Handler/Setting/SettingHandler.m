//
//  SettingHandler.m
//  TDjuwairen
//
//  Created by zdy on 2017/7/27.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "SettingHandler.h"

@implementation SettingHandler

+ (BOOL)isOpenRemoteBell {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kRemoteBell];
}

+ (void)openRemoteBell {
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kRemoteBell];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)closeRemoteBell {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kRemoteBell];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

+ (BOOL)isRemoteShake {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kRemoteShake];
}

+ (void)openRemoteShake {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kRemoteShake];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)closeRemoteShake {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kRemoteShake];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
@end
