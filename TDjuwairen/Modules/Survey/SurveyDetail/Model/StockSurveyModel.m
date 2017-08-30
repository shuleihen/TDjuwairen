//
//  StockSurveyModel.m
//  TDjuwairen
//
//  Created by zdy on 2017/1/13.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "StockSurveyModel.h"

@implementation StockSurveyModel
- (id)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.imageUrl = dict[@"survey_cover"];
        self.title = dict[@"survey_title"];
        self.surveyId = dict[@"survey_id"];
        self.dateTime = dict[@"survey_addtime"];
        self.companyName = dict[@"company_name"];
        self.companyCode = dict[@"company_code"];
        self.surveyType = [dict[@"survey_type"] integerValue];
        self.isUnlock = [dict[@"is_unlock"] boolValue];
        self.isVisited = [dict[@"is_visited"] boolValue];
    }
    return self;
}

- (id)initWithCollectionDict:(NSDictionary *)dict {
    self = [self initWithDict:dict];
    
    self.collectedId = dict[@"collect_id"];
    
    return self;
}

- (BOOL)isCollection {
    return (self.collectedId.length>0);
}
@end
