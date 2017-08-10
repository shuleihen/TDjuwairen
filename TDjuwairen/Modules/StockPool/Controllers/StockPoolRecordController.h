//
//  StockPoolRecordController.h
//  TDjuwairen
//
//  Created by ZYP-MAC on 2017/8/10.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSInteger {
    kOwnStockPool    =1, /// 自己的股票池
    kOtherStockPool    =1, /// 别人的股票池
} StockPoolType;

@interface StockPoolRecordController : UIViewController
@property (nonatomic, assign) StockPoolType stockPoolType;
@end
