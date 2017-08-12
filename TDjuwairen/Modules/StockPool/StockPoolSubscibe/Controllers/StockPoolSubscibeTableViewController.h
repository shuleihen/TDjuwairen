//
//  StockPoolSubscibeTableViewController.h
//  TDjuwairen
//
//  Created by deng shu on 2017/8/12.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

// 调研和热点收藏
typedef enum : NSUInteger {
    kStockPoolSubscibeVCCurrentType    =0,
    kStockPoolSubscibeVCHistoryType       =1,
   
} StockPoolSubscibeVCType;

@interface StockPoolSubscibeTableViewController : UITableViewController
@property (nonatomic, assign) StockPoolSubscibeVCType type;
@end
