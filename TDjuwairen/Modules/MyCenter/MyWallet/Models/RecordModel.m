//
//  RecordModel.m
//  TDjuwairen
//
//  Created by 团大 on 2016/11/23.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "RecordModel.h"

@implementation RecordModel

+ (RecordModel *)getInstanceWithDic:(NSDictionary *)dic
{
    RecordModel *model = [[RecordModel alloc] init];
    model.record_id = dic[@"record_id"];
    model.record_item = dic[@"record_item"];
    model.record_itemid = dic[@"record_itemid"];
    model.record_keynum = dic[@"record_keynum"];
    model.record_time = dic[@"record_time"];
    model.record_type = dic[@"record_type"];
    
    return model;
}


- (NSComparisonResult)compare:(RecordModel *)other
{
    if (self.record_time.integerValue > other.record_time.integerValue) {
        return NSOrderedDescending;
    } else if (self.record_time.integerValue < other.record_time.integerValue) {
        return NSOrderedAscending;
    } else {
        return NSOrderedSame;
    }
}

@end
