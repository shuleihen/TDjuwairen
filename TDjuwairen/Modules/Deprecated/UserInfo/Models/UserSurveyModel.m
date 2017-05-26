//
//  UserSurveyModel.m
//  TDjuwairen
//
//  Created by 团大 on 2016/12/15.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "UserSurveyModel.h"

@implementation UserSurveyModel

+ (UserSurveyModel *)getInstanceWithDic:(NSDictionary *)dic{
    UserSurveyModel *model = [[UserSurveyModel alloc] init];
    model.company_name = dic[@"company_name"];
    model.survey_title = dic[@"survey_title"];
    model.company_code = dic[@"company_code"];
    model.survey_desc = dic[@"survey_desc"];
    model.survey_authorid = dic[@"survey_authorid"];
    model.survey_addtime = dic[@"survey_addtime"];
    model.survey_id = dic[@"survey_id"];
    model.survey_cover = dic[@"survey_cover"];
    return model;
}

@end
