//
//  StockPoolListIntroModel.m
//  TDjuwairen
//
//  Created by zdy on 2017/8/23.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "StockPoolListIntroModel.h"

@implementation StockPoolListIntroModel
- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.firstRecordDay = dict[@"record_first_day"];
        self.shareURL = dict[@"share_url"];
        self.intro = dict[@"pool_desc"];
        self.commentNum = [dict[@"pool_comment_num"] integerValue];
        self.subscribeNum = [dict[@"new_subscribe_num"] integerValue];
        self.isMaster = [dict[@"is_master"] boolValue];
        self.expireTime = [dict[@"user_expire_time"] integerValue];
        self.expireDay = [dict[@"pool_set_expire_day"] integerValue];
        self.isSubscribed = [dict[@"user_is_subscribe"] boolValue];
        self.masterNickName = dict[@"user_nickname"];
        self.masterAvatar = dict[@"userinfo_facemin"];
        self.isFree = [dict[@"pool_is_free"] boolValue];
    }
    return self;
}
@end
