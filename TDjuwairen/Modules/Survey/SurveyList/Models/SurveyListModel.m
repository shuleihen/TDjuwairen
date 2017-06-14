//
//  SurveyListModel.m
//  TDjuwairen
//
//  Created by zdy on 2016/11/22.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "SurveyListModel.h"

@implementation SurveyListModel
+ (SurveyListModel *)getInstanceWithDictionary:(NSDictionary *)dic {
    SurveyListModel *model = [[SurveyListModel alloc] init];
    model.surveyType = [dic[@"survey_type"] integerValue];
    model.surveyCover = dic[@"survey_cover"];
    model.surveyUrl = dic[@"survey_url"];
    model.companyCode = dic[@"company_code"];
    model.companyName = dic[@"company_name"];
    model.surveyId = dic[@"survey_id"];
    model.surveyTitle = dic[@"survey_title"];
    model.stockCode = dic[@"stock_code"];
    model.addTime = dic[@"survey_addtime"];
    model.isUnlocked = [dic[@"is_unlock"] boolValue];
    model.unlockKeyNum = [dic[@"unlock_keynum"] integerValue];
    model.isVisited = [dic[@"is_visited"] boolValue];
    
    return model;
}

//- (NSComparisonResult)compare:(SurveyListModel *)other
//{
//    if (self..integerValue > other.order_ptime.integerValue) {
//        return NSOrderedDescending;
//    } else if (self.order_ptime.integerValue < other.order_ptime.integerValue) {
//        return NSOrderedAscending;
//    } else {
//        return NSOrderedSame;
//    }
//}
@end
