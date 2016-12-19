//
//  StockMarketViewController.h
//  TDjuwairen
//
//  Created by zdy on 2016/12/16.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    kStockTypeSZ,
    kStockTypeCY
} StockType;

@interface StockMarketViewController : UIViewController
@property (nonatomic, assign) StockType stockType;
@end
