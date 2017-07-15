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
        self.stockCode = dict[@"guess_stock"];
        self.stockName = dict[@"guess_name"];
        self.endPrice = dict[@"guess_end_price"];
        self.addTime = dict[@"item_addtime"];
        self.status = [dict[@"guess_status"] intValue];
        self.keyNumber = [dict[@"item_keynum"] intValue];
        self.season = [dict[@"guess_season"] intValue];
        self.guessDate = dict[@"guess_date"];
        self.guessPoint = dict[@"item_points"];
        self.joinNum = [dict[@"guess_item_count"] integerValue];
        self.winKeyNum = [dict[@"guess_win_keynum"] integerValue];
        self.winnerNum = [dict[@"guess_winner_count"] integerValue];
        self.extraKeyNum = [dict[@"guess_extra_keynum"] integerValue];
    }
    return self;
}

- (BOOL)isWin {
    return (self.status == 1||self.status==2);
}
@end
