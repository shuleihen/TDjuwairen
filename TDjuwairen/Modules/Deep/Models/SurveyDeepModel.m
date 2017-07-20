//
//  SurveyDeepModel.m
//  TDjuwairen
//
//  Created by zdy on 2017/7/20.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "SurveyDeepModel.h"

@implementation SurveyDeepModel
- (id)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.surveyId = dict[@"survey_id"];
        self.surveyTitle = dict[@"survey_title"];
        self.surveyType = [dict[@"survey_type"] integerValue];
        self.addTime = dict[@"survey_addtime"];
        self.isVisited = [dict[@"is_visited"] boolValue];
        self.isUnlock = [dict[@"is_unlock"] boolValue];
        self.unlockKeyNum = [dict[@"unlock_keynum"] integerValue];
        self.deepPayTip = dict[@"deep_pay_tip"];
        self.deepPayType = [dict[@"deep_pay_type"] integerValue];
        self.desc = dict[@"survey_desc"];
        self.stockCode = dict[@"company_code"];
        self.cover = dict[@"survey_cover"];
    }
    return self;
}
@end
