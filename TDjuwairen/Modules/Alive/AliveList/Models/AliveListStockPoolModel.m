//
//  AliveListStockPoolModel.m
//  TDjuwairen
//
//  Created by zdy on 2017/8/11.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveListStockPoolModel.h"

@implementation AliveListStockPoolModel
- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.masterId = dict[@"pool_master_id"];
        self.userAvatar = dict[@"userinfo_facemin"];
        self.userNickName = dict[@"user_nickname"];
        self.isFree = [dict[@"pool_is_free"] boolValue];
        self.isMaster = [dict[@"is_master"] boolValue];
        self.poolSetTip = dict[@"pool_set_tip"];
        self.subscribeNum = [dict[@"pool_subscribe_num"] integerValue];
        self.isExpire = [dict[@"user_subscribe_expire"] boolValue];
        self.isSubscribe = [dict[@"user_is_subscribe"] boolValue];
        self.poolDesc = dict[@"pool_desc"];
        self.poolLogo = dict[@"pool_logo"];
    }
    
    return self;
}
@end
