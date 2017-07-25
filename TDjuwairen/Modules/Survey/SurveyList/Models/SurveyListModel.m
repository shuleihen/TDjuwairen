//
//  SurveyListModel.m
//  TDjuwairen
//
//  Created by zdy on 2016/11/22.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "SurveyListModel.h"

@implementation SurveyListModel

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.surveyType = [dict[@"survey_type"] integerValue];
        self.surveyCover = dict[@"survey_cover"];
        self.surveyUrl = dict[@"survey_url"];
        self.companyCode = dict[@"company_code"];
        self.companyName = dict[@"company_name"];
        self.surveyId = dict[@"survey_id"];
        self.surveyTitle = dict[@"survey_title"];
        self.stockCode = dict[@"stock_code"];
        self.addTime = dict[@"survey_addtime"];
        self.isUnlocked = [dict[@"is_unlock"] boolValue];
        self.unlockKeyNum = [dict[@"unlock_keynum"] integerValue];
        self.isVisited = [dict[@"is_visited"] boolValue];
        self.deepPayTip = dict[@"deep_pay_tip"];
        self.deepPayType = [dict[@"deep_pay_type"] integerValue];
    }
    return self;
}

- (id)initWithOptionalDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.surveyType = [dict[@"survey_type"] integerValue];
        self.surveyCover = dict[@"survey_cover"];
        self.surveyUrl = dict[@"survey_url"];
        self.companyCode = dict[@"company_code"];
        self.companyName = dict[@"company_name"];
        self.surveyId = dict[@"survey_id"];
        self.surveyTitle = dict[@"survey_title"];
        self.stockCode = dict[@"stock_code"];
        self.addTime = dict[@"survey_addtime"];
        self.isNewAlive = [dict[@"is_new_alive"] boolValue];
        self.surveyTitleType = [dict[@"survey_title_pre"] integerValue];
    }
    return self;
}
@end
