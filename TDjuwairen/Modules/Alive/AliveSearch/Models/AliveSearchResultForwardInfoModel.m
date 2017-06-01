//
//  AliveSearchResultForwardInfoModel.m
//  TDjuwairen
//
//  Created by ZYP-MAC on 17/6/1.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveSearchResultForwardInfoModel.h"

@implementation AliveSearchResultForwardInfoModel
/// 话题列表
- (id)initWithTopicForwardInfoDict:(NSDictionary *)dict {
    if (self = [super init]) {
        _userNickName = dict[@"user_nickname"];
         _company_code = dict[@"company_code"];
        _aliveImg = dict[@"alive_img"];
        _aliveType = dict[@"alive_type"];
        _aliveId = dict[@"alive_id"];
        _aliveTitle = dict[@"alive_title"];
        _aliveMasterId = dict[@"alive_master_id"];
        _aliveComTag = dict[@"alive_com_tag"];
        _forwardUrl = dict[@"forward_url"];
        _isLock = [dict[@"is_lock"] boolValue];
    }
    return self;
    
}
@end
