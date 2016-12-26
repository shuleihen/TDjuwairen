//
//  StockMarketModel.m
//  TDjuwairen
//
//  Created by zdy on 2016/12/19.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "StockMarketModel.h"

@implementation StockMarketModel
- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.endtime = [dict[@"endtime"] floatValue];
        self.date = [dict[@"date"] stringValue];
        self.isWorking = [dict[@"is_working"] boolValue];
        self.price = [dict[@"price"] floatValue];
        self.isJoin = [dict[@"user_guess"] boolValue];
        self.joinType = [dict[@"user_guess_type"] intValue];
        self.upPre = [dict[@"up_pre"] floatValue];
    }
    return self;
}
@end
