//
//  UILabel+StockCode.h
//  TDjuwairen
//
//  Created by zdy on 2017/7/14.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StockManager.h"

@interface UILabel (StockCode)
- (void)setupForGuessDetailStockInfo:(StockInfo *)stock;
- (void)setupForStockPoolDetailStockInfo:(StockInfo *)stock;
@end
