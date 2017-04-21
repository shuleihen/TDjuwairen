//
//  TencentStockManager.h
//  TDjuwairen
//
//  Created by zdy on 2017/4/18.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StockManager.h"

@interface TencentStockManager : NSObject
- (void)queryStock:(NSString *)stockCode completion:(void (^)(id data, NSError *error))completion;
@end
