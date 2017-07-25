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
        _survey_type = [dict[@"survey_type"] integerValue];
         _unlockKeynum = dict[@"unlock_keynum"];
        _isUnlock = [dict[@"is_unlock"] boolValue];
        _deepPayTip = dict[@"deep_pay_tip"];
        _deepPayType = [dict[@"deep_pay_type"] integerValue];
    }
    return self;
}

///// 话题 推单列表
//- (id)initWithTopicListDict:(NSDictionary *)dict {
//    if (self = [super init]) {
//        _userNickName = dict[@"user_nickname"];
//        _userIcon = dict[@"userinfo_facemin"];
//        _aliveTime = dict[@"alive_time"];
//        _aliveImg = dict[@"alive_img"];
//        _aliveType = dict[@"alive_type"];
//        _aliveId = dict[@"alive_id"];
//        _aliveTitle = dict[@"alive_title"];
//        _aliveMasterId = dict[@"alive_master_id"];
//        _aliveShareUrl = SafeValue(dict[@"alive_share_url"]);
//        _aliveComTag = dict[@"alive_com_tag"];
//         _isForward = [dict[@"is_forward"] boolValue];
//        _isOfficial = [dict[@"is_official"] boolValue];
//        _isSelf = [dict[@"is_self"] boolValue];
//        _isAttend = [dict[@"is_attend"] boolValue];
//        _forward_info = [[AliveSearchResultForwardInfoModel alloc] initWithTopicForwardInfoDict:dict[@"forward_info"]];
//    }
//    return self;
//    
//}


///// 观点列表
//- (id)initWithViewPointListDict:(NSDictionary *)dict {
//    if (self = [super init]) {
//        _userNickName = dict[@"user_nickname"];
//        _userIcon = dict[@"userinfo_facemin"];
//        _isSelf = [dict[@"is_self"] boolValue];
//        _isOfficial = [dict[@"is_official"] boolValue];
//        _aliveTime = dict[@"alive_time"];
//        _aliveImg = dict[@"alive_img"];
//        _aliveType = dict[@"alive_type"];
//        _aliveId = dict[@"alive_id"];
//        _aliveTitle = dict[@"alive_title"];
//        _aliveMasterId = dict[@"alive_master_id"];
//        _aliveComTag = dict[@"alive_com_tag"];
//        
//    }
//    return self;
//    
//}

@end
