//
//  IndividualStockRecordModel.m
//  TDjuwairen
//
//  Created by zdy on 2017/4/11.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "IndividualStockRecordModel.h"

@implementation IndividualStockRecordModel
- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.guessId = dict[@"item_id"];
        self.stockId = dict[@"guess_stock"];
        self.stockName = dict[@"guess_name"];
        self.endPrice = dict[@"guess_end_price"];
        self.addTime = dict[@"item_addtime"];
        self.status = [dict[@"guess_status"] intValue];
        self.keyNumber = [dict[@"item_keynum"] intValue];
        self.season = [dict[@"guess_season"] intValue];
        self.guessDate = dict[@"guess_date"];
        self.guessReword = dict[@"guess_reword"];
        self.guessPoint = dict[@"item_points"];
        
        if (self.season == 1) {
            self.seasonString = @"上午场";
        } else if (self.season == 2) {
            self.seasonString = @"下午场";
        }
    }
    return self;
}
@end
