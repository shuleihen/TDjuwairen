//
//  StockGuessInfo.m
//  TDjuwairen
//
//  Created by zdy on 2016/12/27.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "StockGuessInfo.h"

@implementation StockGuessInfo
- (id)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.guessId = dict[@"guess_id"];
        self.type = [dict[@"guess_type"] integerValue];
        self.season = [dict[@"guess_season"] integerValue];
        self.isClosed = [dict[@"guess_isclose"] boolValue];
        self.enable = [dict[@"user_guess_enable"] boolValue];
        self.stockName = dict[@"guess_name"];
        self.stockId = dict[@"stock_code"];
        self.endTime = [dict[@"guess_endtime"] longLongValue];
    }
    return self;
}
@end
