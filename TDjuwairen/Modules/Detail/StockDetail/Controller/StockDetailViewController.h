//
//  StockDetailViewController.h
//  TDjuwairen
//
//  Created by zdy on 2016/11/29.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StockManager.h"
#import "SurveyModel.h"

@interface StockDetailViewController : UITableViewController

// stockId 为新浪股票id 包含前缀 sh
@property (nonatomic, strong) NSString *stockId;

@property (nonatomic, strong) StockInfo *stockInfo;
@end
