//
//  StockUnlockViewController.h
//  TDjuwairen
//
//  Created by zdy on 2016/12/21.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StockUnlockModel.h"

@protocol StockUnlockDelegate <NSObject>
- (void)unlockWithStockCode:(NSString *)stockCode;
- (void)rechargePressed:(id)sender;
- (void)vipPressed:(id)sender;
@end

@interface StockUnlockViewController : UIViewController
@property (nonatomic, strong) StockUnlockModel *model;

@property (nonatomic, weak) id<StockUnlockDelegate> delegate;
@end
