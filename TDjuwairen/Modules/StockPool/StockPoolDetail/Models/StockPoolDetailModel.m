//
//  StockPoolDetailModel.m
//  TDjuwairen
//
//  Created by zdy on 2017/8/16.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "StockPoolDetailModel.h"

@implementation StockPoolDetailModel
- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.desc = dict[@"record_desc"];
        self.recordId = dict[@"record_id"];
        long long d = [dict[@"record_time"] longLongValue];
        self.date = [NSDate dateWithTimeIntervalSince1970:d];
        self.ratio = dict[@"record_total_ratio"];
        self.masterId = dict[@"record_master_id"];
        self.isMaster = [dict[@"is_master"] boolValue];
        self.shareUrl = dict[@"share_url"];
        self.shareIcon = dict[@"stock_pool_logo"];
        self.isNewRecord = [dict[@"record_is_new"] boolValue];
        
        NSArray *list = dict[@"record_position_data"];
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:list.count];
        for (NSDictionary *dic in list) {
            SPEditRecordModel *model = [[SPEditRecordModel alloc] initWithDictionary:dic];
            [array addObject:model];
        }
        self.positions = array;
    }
    return self;
}
@end
