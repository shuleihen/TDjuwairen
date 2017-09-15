//
//  StockPoolListCellModel.m
//  TDjuwairen
//
//  Created by ZYP-MAC on 2017/8/14.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "StockPoolListCellModel.h"

@implementation StockPoolListCellModel
- (instancetype)initWithDict:(NSDictionary *)dict {
    
    if (self = [super init]) {
        
        _record_desc = dict[@"record_desc"];
        _record_id = dict[@"record_id"];
        _record_is_visited = [dict[@"record_is_visited"] boolValue];
        _record_total_ratio = dict[@"record_total_ratio"];
        _record_is_unlock = [dict[@"record_is_unlock"] boolValue];
        _record_is_new = [dict[@"record_is_new"] boolValue];
        _record_time = dict[@"record_time"];
    }
    return self;
}

- (NSString *)getWeekDayStr:(NSInteger)week {
    NSString *str = @"";
    switch (week) {
        case 1:
            str = @"周日";
            break;
        case 2:
            str = @"周一";
            break;
        case 3:
            str = @"周二";
            break;
        case 4:
            str = @"周三";
            break;
        case 5:
            str = @"周四";
            break;
        case 6:
            str = @"周五";
            break;
        case 7:
            str = @"周六";
            break;
        default:
            break;
    }
    return str;
}


@end
