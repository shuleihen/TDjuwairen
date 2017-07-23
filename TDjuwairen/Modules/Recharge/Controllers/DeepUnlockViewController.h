//
//  DeepUnlockViewController.h
//  TDjuwairen
//
//  Created by zdy on 2017/7/21.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StockUnlockModel.h"

@protocol DeepUnlockDelegate <NSObject>
- (void)unlockDeepWithDeepId:(NSString *)deepId;
- (void)rechargePressed:(id)sender;
- (void)vipPressed:(id)sender;
@end

@interface DeepUnlockViewController : UIViewController
@property (nonatomic, strong) StockUnlockModel *unlockModel;
@property (nonatomic, weak) id<DeepUnlockDelegate> delegate;
@end
