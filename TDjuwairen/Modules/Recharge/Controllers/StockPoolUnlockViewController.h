//
//  StockPoolUnlockViewController.h
//  TDjuwairen
//
//  Created by zdy on 2017/8/17.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StockPoolUnlockModel.h"

@protocol StockPoolUnlockDelegate <NSObject>
- (void)unlockWithStockPoolMasterId:(NSString *)masterId;
- (void)rechargePressed:(id)sender;
- (void)vipPressed:(id)sender;
@end

@interface StockPoolUnlockViewController : UIViewController
@property (nonatomic, strong) StockPoolUnlockModel *unlockModel;
@property (nonatomic, weak) id<StockPoolUnlockDelegate> delegate;
@end

