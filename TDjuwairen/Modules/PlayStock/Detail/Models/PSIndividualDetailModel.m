//
//  PSIndividualDetailModel.m
//  TDjuwairen
//
//  Created by zdy on 2017/7/12.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "PSIndividualDetailModel.h"

@implementation PSIndividualDetailModel
- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.endTime = [dict[@"guess_endtime"] longLongValue];
        self.guessId = dict[@"guess_id"];
        self.stockName = dict[@"guess_company"];
        self.stockCode = dict[@"com_code"];
        self.season = [dict[@"guess_season"] integerValue];
        self.status = [dict[@"guess_status"] integerValue];
        self.allKeyNum = [dict[@"guess_key_num"] integerValue];
        self.joinNum = [dict[@"guess_item_num"] integerValue];
        self.isJoin = [dict[@"has_join"] boolValue];
        self.artileInfo = dict[@"artile_info"];
    }
    return self;
}

- (id)initWithDetailDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.endTime = [dict[@"guess_endtime"] longLongValue];
        self.guessId = dict[@"guess_id"];
        self.stockName = dict[@"guess_company"];
        self.stockCode = dict[@"com_code"];
        self.season = [dict[@"guess_season"] integerValue];
        self.status = [dict[@"guess_status"] integerValue];
        self.allKeyNum = [dict[@"guess_key_num"] integerValue];
        self.joinNum = [dict[@"guess_item_num"] integerValue];
        self.isJoin = [dict[@"has_join"] boolValue];

    }
    return self;
}
@end
