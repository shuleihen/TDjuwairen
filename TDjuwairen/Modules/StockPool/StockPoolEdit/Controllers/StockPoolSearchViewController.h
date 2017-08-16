//
//  StockPoolSearchViewController.h
//  TDjuwairen
//
//  Created by zdy on 2017/8/16.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface StockPoolSearchViewController : UIViewController
@property (nonatomic, copy) void (^selectedBlock) (NSString *stockName, NSString *stockCode);
@end
