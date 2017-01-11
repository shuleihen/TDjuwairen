//
//  SearchResultModel.m
//  TDjuwairen
//
//  Created by zdy on 2017/1/11.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "SearchResultModel.h"

@implementation SearchResultModel
- (id)initWithStockDict:(NSDictionary *)dict {
    if (self = [super init]) {
//        _resultId = 
    }
    return self;
}

- (id)initWithSurveyDict:(NSDictionary *)dict {
    if (self = [super init]) {
        _resultId = dict[@"survey_companycode"];
        _title = dict[@"survey_title"];
    }
    return self;
}

- (id)initWithViewpointDict:(NSDictionary *)dict {
    if (self = [super init]) {
        _resultId = dict[@"view_id"];
        _title = dict[@"view_title"];
    }
    return self;
}
@end
