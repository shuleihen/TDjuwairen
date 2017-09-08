//
//  SettingHandler.m
//  TDjuwairen
//
//  Created by zdy on 2017/7/27.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "SettingHandler.h"
#import "LoginStateManager.h"

@implementation SettingHandler
+ (NSString *)fullKeyUnionUserIdWithKey:(NSString *)key {
    return [NSString stringWithFormat:@"%@_%@",US.userId,key];
}

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

+ (BOOL)isShowSettingStockPoolDescTip {
    NSString *key = [self fullKeyUnionUserIdWithKey:kSPIsSettingDescTip];
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

+ (void)addSettingStockPoolDesc {
    NSString *key = [self fullKeyUnionUserIdWithKey:kSPIsSettingDescTip];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isAddFistStockPoolRecord {
    NSString *key = [self fullKeyUnionUserIdWithKey:kSPFistAddTip];
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

+ (void)addFirstStockPoolRecord {
    NSString *key = [self fullKeyUnionUserIdWithKey:kSPFistAddTip];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSInteger)getAddStockPoolRecordCountInOneDay {
    NSString *key = [self fullKeyUnionUserIdWithKey:kSPAddRecordCount];
    return [[NSUserDefaults standardUserDefaults] integerForKey:key];
}

+ (void)addStockPoolRecord {
    NSString *key = [self fullKeyUnionUserIdWithKey:kSPAddRecordCount];
    NSInteger count = [[NSUserDefaults standardUserDefaults] integerForKey:key];
    [[NSUserDefaults standardUserDefaults] setInteger:(count+1) forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)subtractStockPoolRecord {
    NSString *key = [self fullKeyUnionUserIdWithKey:kSPAddRecordCount];
    NSInteger count = [[NSUserDefaults standardUserDefaults] integerForKey:key];
    [[NSUserDefaults standardUserDefaults] setInteger:(count-1) forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)clearAddStockPoolRecordCount {
    NSString *key = [self fullKeyUnionUserIdWithKey:kSPAddRecordCount];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)saveStockHolderOpenTime:(NSInteger)time {
    NSString *key = [self fullKeyUnionUserIdWithKey:kPublishStockHolderTime];
    [[NSUserDefaults standardUserDefaults] setInteger:time forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSInteger)getStockHolderOpenTime {
    NSString *key = [self fullKeyUnionUserIdWithKey:kPublishStockHolderTime];
    return [[NSUserDefaults standardUserDefaults] integerForKey:key];
}

+ (void)saveStockHolderName:(NSString *)stockHolderName {
    NSString *key = [self fullKeyUnionUserIdWithKey:kPublishStockHolderName];
    [[NSUserDefaults standardUserDefaults] setObject:stockHolderName forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getStockHolderName {
    NSString *key = [self fullKeyUnionUserIdWithKey:kPublishStockHolderName];
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}
@end
