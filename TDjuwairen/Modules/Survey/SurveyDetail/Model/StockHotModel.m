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
        _isVisited = [dict[@"is_visited"] boolValue];
    }
    return self;
}

- (id)initWithCollectionDict:(NSDictionary *)dict {
    self = [self initWithDict:dict];
    
    self.collectedId = dict[@"collect_id"];
    self.companyName = dict[@"company_name"];
    self.companyCode = dict[@"company_code"];
    
    return self;
}

- (BOOL)isCollection {
    return (self.collectedId.length>0);
}
@end
