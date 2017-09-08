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

// 首次添加股票池送3把钥匙
+ (BOOL)isAddFistStockPoolRecord;
+ (void)addFirstStockPoolRecord;

+ (BOOL)isShowSettingStockPoolDescTip;
+ (void)addSettingStockPoolDesc;

// 每天只能发2条
+ (void)addStockPoolRecord;
+ (NSInteger)getAddStockPoolRecordCountInOneDay;
+ (void)clearAddStockPoolRecordCount;

+ (void)saveStockHolderOpenTime:(NSInteger)time;
+ (NSInteger)getStockHolderOpenTime;
+ (void)saveStockHolderName:(NSString *)stockHolderName;
+ (NSString *)getStockHolderName;
@end
