//
//  GradeDetailModel.m
//  TDjuwairen
//
//  Created by zdy on 2017/1/17.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "GradeDetailModel.h"

@implementation GradeItem
- (id)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        _order = dict[@"item_tag"];
        _title = dict[@"item_title"];
        _desc = dict[@"item_desc"];
        _score = dict[@"item_score"];
    }
    return self;
}

@end

@implementation GradeDetailModel
- (id)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        _canGrade = [dict[@"user_enable_rate"] boolValue];
        _lastTime = [dict[@"next_rate_time"] integerValue];
        _stockName = dict[@"company_name"];
        _stockId = dict[@"company_code"];
        
        NSArray *array = dict[@"grades"];
        NSMutableArray *marray = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary *dict in array) {
            GradeItem *item = [[GradeItem alloc] initWithDict:dict];
            [marray addObject:item];
        }
        _itemGrades = marray;
    }
    return self;
}
@end
