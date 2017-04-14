//
//  PlayListModel.m
//  TDjuwairen
//
//  Created by deng shu on 2017/3/28.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "PlayListModel.h"

@implementation PlayListModel



- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.guess_company = dict[@"guess_company"];
        self.guess_end_price = dict[@"guess_end_price"];
        self.guess_status = dict[@"guess_status"];
        self.guess_season = dict[@"guess_season"];
        self.guess_key_num = dict[@"guess_key_num"];
        self.guess_id = dict[@"guess_id"];
        self.com_code = dict[@"com_code"];
        self.guess_item_num = [dict[@"guess_item_num"] integerValue];
        self.has_join = [dict[@"has_join"] boolValue];
        self.winner_list = dict[@"winner_list"];
        self.artile_info = dict[@"artile_info"];
        self.stock = dict[@"stock"];
    }
    
    return self;
}
@end
