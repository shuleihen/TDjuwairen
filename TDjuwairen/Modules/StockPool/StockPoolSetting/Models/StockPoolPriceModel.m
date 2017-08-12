//
//  StockPoolPriceModel.m
//  TDjuwairen
//
//  Created by deng shu on 2017/8/12.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "StockPoolPriceModel.h"

@implementation StockPoolPriceModel
- (instancetype)initWithDict:(NSDictionary *)dict {
    
    if(self = [super init]) {
        self.is_free = dict[@"pool_is_free"];
        self.key_num = dict[@"pool_set_keynum"];
        self.day = dict[@"pool_set_expire_day"];
    }
    return self;
}

@end
