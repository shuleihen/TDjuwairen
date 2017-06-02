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

- (void)unlockManager:(StockUnlockManager *)manager withStockCode:(NSString *)stockCode;
@end

@interface StockUnlockManager : NSObject
@property (nonatomic, weak) id<StockUnlockManagerDelegate> delegate;

- (void)unlockStock:(NSString *)stockCode withStockName:(NSString *)stockName withController:(UIViewController *)controller;
@end
