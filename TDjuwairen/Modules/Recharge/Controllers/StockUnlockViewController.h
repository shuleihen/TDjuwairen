//
//  StockUnlockViewController.h
//  TDjuwairen
//
//  Created by zdy on 2016/12/21.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol StockUnlockDelegate <NSObject>
- (void)unlockPressed:(id)sender;
- (void)rechargePressed:(id)sender;

@end

@interface StockUnlockViewController : UIViewController
@property (nonatomic, strong) NSString *stockCode;
@property (nonatomic, strong) NSString *stockName;
@property (nonatomic, assign) NSInteger needKey;

@property (nonatomic, weak) id<StockUnlockDelegate> delegate;
@end
