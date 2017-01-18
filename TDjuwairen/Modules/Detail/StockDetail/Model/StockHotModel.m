//
//  StockHotModel.m
//  TDjuwairen
//
//  Created by zdy on 2017/1/18.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "StockHotModel.h"

@implementation StockHotModel
- (id)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        _source = dict[@"hot_source"];
        _title = dict[@"hot_title"];
        _hotId = dict[@"hot_id"];
        _dateTime = dict[@"hot_addtime"];
    }
    return self;
}
@end