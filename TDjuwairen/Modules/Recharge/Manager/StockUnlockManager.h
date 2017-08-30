//
//  StockUnlockManager.h
//  TDjuwairen
//
//  Created by zdy on 2017/6/2.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@class StockUnlockManager;
@protocol StockUnlockManagerDelegate <NSObject>
@optional
- (void)unlockManager:(StockUnlockManager *)manager withDeepId:(NSString *)deepId;
- (void)unlockManager:(StockUnlockManager *)manager withMasterId:(NSString *)masterId;
- (void)unlockManager:(StockUnlockManager *)manager withSurveyId:(NSString *)surveyId;
@end

@interface StockUnlockManager : NSObject
@property (nonatomic, weak) id<StockUnlockManagerDelegate> delegate;

// 解锁股票调研
- (void)unlockSurvey:(NSString *)surveyId withSurveyType:(NSInteger)surveyType withSureyTitle:(NSString *)surveyTitle withController:(UIViewController *)controller;

// 解锁深度调研
- (void)unlockDeep:(NSString *)deepId withController:(UIViewController *)controller;

// 订阅股票池
- (void)unlockStockPool:(NSString *)masterId withController:(UIViewController *)controller;

@end
