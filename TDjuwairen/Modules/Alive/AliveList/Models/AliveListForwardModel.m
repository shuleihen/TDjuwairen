//
//  AliveListForwardModel.m
//  TDjuwairen
//
//  Created by zdy on 2017/3/30.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveListForwardModel.h"

@implementation AliveListForwardModel
- (id)initWithDictionary:(NSDictionary *)dict {
    if (self =  [super init]) {
        self.aliveId = dict[@"alive_id"];
        self.aliveType = [dict[@"alive_type"] integerValue];
        self.aliveImg = dict[@"alive_img"];
        self.aliveImgs = dict[@"alive_images"];
        self.aliveTitle = dict[@"alive_title"];
        self.aliveTime = dict[@"alive_time"];
        self.masterId = dict[@"alive_master_id"];
        self.masterNickName = dict[@"user_nickname"];
        self.aliveTags = dict[@"alive_com_tag"];
        self.stockCode = dict[@"company_code"];
        self.forwardUrl = dict[@"forward_url"];
        self.isLocked = [dict[@"is_lock"] boolValue];
    }
    return self;
}
@end
