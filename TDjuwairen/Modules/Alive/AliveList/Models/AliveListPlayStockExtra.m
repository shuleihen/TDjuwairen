//
//  AliveListPlayStockExtra.m
//  TDjuwairen
//
//  Created by zdy on 2017/7/19.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveListPlayStockExtra.h"

@implementation AliveListPlayStockExtra
- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.companyName = dict[@"company_name"];
        self.companyCode = dict[@"company_code"];
        self.guessId = dict[@"guess_id"];
        self.guessTime = dict[@"guess_date"];
        self.guessSeason = dict[@"guess_season"];
    }
    
    return self;
}
@end
