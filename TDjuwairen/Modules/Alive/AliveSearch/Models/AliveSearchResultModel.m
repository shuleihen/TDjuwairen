//
//  AliveSearchResultModel.m
//  TDjuwairen
//
//  Created by ZYP-MAC on 17/5/31.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveSearchResultModel.h"

@implementation AliveSearchResultModel
/// 用户列表
- (id)initWithUserListDict:(NSDictionary *)dict {
    if (self = [super init]) {
        _userID = dict[@"user_id"];
        _userIcon = dict[@"userinfo_facemin"];
        _userNickName = dict[@"user_nickname"];
        _isAttend = [dict[@"is_attend"] boolValue];
    }
    return self;
}

/// 股票列表
- (id)initWithStockListDict:(NSDictionary *)dict {
    if (self = [super init]) {
        _company_name = dict[@"company_name"];
        _company_code = dict[@"company_code"];
        _userNickName = dict[@"user_nickname"];
        _isMyStock = [dict[@"is_mystock"] boolValue];
    }
    return self;
}

/// 调研列表
- (id)initWithSurveyListDict:(NSDictionary *)dict {

    if (self = [super init]) {
        _survey_id = dict[@"survey_id"];
        _company_name = dict[@"company_name"];
        _company_code = dict[@"company_code"];
        _surveyAddtime = dict[@"survey_addtime"];
        _survey_title = dict[@"survey_title"];
        _survey_type = dict[@"survey_type"];
         _unlockKeynum = dict[@"unlock_keynum"];
        _isUnlock = [dict[@"is_unlock"] boolValue];
    }
    return self;
}

@end
