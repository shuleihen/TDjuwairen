//
//  PSIndividualListModel.m
//  TDjuwairen
//
//  Created by deng shu on 2017/3/28.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "PSIndividualListModel.h"

@implementation PSIndividualListModel



- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.stockName = dict[@"guess_company"];
        self.guess_end_price = dict[@"guess_end_price"];
        self.guess_status = dict[@"guess_status"];
        self.guess_season = dict[@"guess_season"];
        self.guess_key_num = dict[@"guess_key_num"];
        self.guessId = dict[@"guess_id"];
        self.stockCode = dict[@"com_code"];
        self.guess_item_num = [dict[@"guess_item_num"] integerValue];
        self.has_join = [dict[@"has_join"] boolValue];
        self.winner_list = dict[@"winner_list"];
        self.artile_info = dict[@"artile_info"];
        self.stockId = dict[@"stock"];
        self.isReward = [dict[@"is_backstart"] boolValue];
    }
    
    return self;
}
@end
