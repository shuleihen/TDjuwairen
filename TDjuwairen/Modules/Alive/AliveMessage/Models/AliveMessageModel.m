//
//  AliveMessageModel.m
//  TDjuwairen
//
//  Created by zdy on 2017/3/13.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveMessageModel.h"

@implementation AliveMessageModel

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.aliveId = dict[@"alive_id"];
        self.messageId = dict[@"notify_id"];
        self.aliveType = [dict[@"alive_type"] integerValue];
        self.aliveContentType = [dict[@"alive_content_type"] integerValue];
        self.messageType = [dict[@"notify_type"] integerValue];
        self.messageContent = dict[@"notify_content"];
        self.aliveContent = dict[@"alive_content"];
        self.nickName = dict[@"user_nickname"];
        self.avatar = dict[@"userinfo_facemin"];
        self.time = dict[@"notify_ptime"];
    }
    return self;
}
@end
