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
        _imageUrl = dict[@"survey_cover"];
        _title = dict[@"survey_title"];
        _surveyId = dict[@"survey_id"];
        _dateTime = dict[@"survey_addtime"];
    }
    return self;
}
@end
