//
//  MyGuessInfo.m
//  TDjuwairen
//
//  Created by zdy on 2016/12/27.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "MyGuessInfo.h"

@implementation MyGuessInfo
- (id)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.type = [dict[@"guess_type"] integerValue];
        self.endTime = [dict[@"guess_endtime"] doubleValue];
        self.endPri = [dict[@"guess_end_price"] floatValue];
        self.isClosed = [dict[@"guess_isclose"] boolValue];
        self.season = [dict[@"guess_season"] integerValue];
        self.buyIndex = [dict[@"item_points"] floatValue];
        self.buyKeyNum = [dict[@"item_keynum"] integerValue];
        self.addTime = dict[@"item_addtime"];
        self.isWin = [dict[@"item_iswin"] boolValue];
        self.odds = [dict[@"item_odds"] floatValue];
        self.stockName = dict[@"guess_name"];
        self.status = [dict[@"guess_status"] integerValue];
        self.statusString = dict[@"guess_reword"];
    }
    return self;
}
@end
