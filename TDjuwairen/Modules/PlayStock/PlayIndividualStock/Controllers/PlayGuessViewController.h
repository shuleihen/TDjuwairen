//
//  PlayGuessViewController.h
//  TDjuwairen
//
//  Created by deng shu on 2017/3/28.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StockManager.h"

@protocol PlayGuessViewControllerDelegate <NSObject>
- (void)addGuessWithStockCode:(NSString *)stockId pri:(float)pri season:(NSInteger)season isJoin:(BOOL)isJoin isForward:(BOOL)isForward;
@end

@interface PlayGuessViewController : UIViewController

@property (nonatomic, assign) id<PlayGuessViewControllerDelegate> delegate;

@property (nonatomic, assign) BOOL isJoin;
@property (nonatomic, assign) NSInteger season;
@property (nonatomic, assign) NSInteger endtime;

- (void)setupDefaultStock:(StockInfo *)stockInfo withStockCode:(NSString *)stockCode;
@end
