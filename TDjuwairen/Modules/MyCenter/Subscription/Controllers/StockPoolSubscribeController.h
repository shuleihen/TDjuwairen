//
//  StockPoolSubscribeController.h
//  TDjuwairen
//
//  Created by deng shu on 2017/8/20.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
// 个人中心   我的订阅列表和历史订阅列表
typedef enum : NSUInteger {
    kMCSPSubscibeVCCurrentType    =0,
    kMCSPSubscibeVCHistoryType       =1,
    
} MCSPSubscibeVCType;

@interface StockPoolSubscribeController : UIViewController
@property (nonatomic, assign) MCSPSubscibeVCType vcType;

@end
