//
//  MessageListModel.m
//  TDjuwairen
//
//  Created by zdy on 2017/6/16.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "MessageListModel.h"

@implementation MessageListModel
- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.recordId = dict[@"record_id"];
        self.itemId = dict[@"item_id"];
        self.userAvatar = dict[@"userinfo_facemin"];
        self.dateTime = dict[@"msg_time"];
        self.msgContent = dict[@"msg_content"];
        self.msgType = [dict[@"item_type"] integerValue];
        self.userNickName = dict[@"user_nickname"];
        self.rightContent = dict[@"right_content"];
        self.rightType = [dict[@"right_content_type"] integerValue];
        self.rightExtra = dict[@"return_extra"];
        self.isRead = [dict[@"has_read"] boolValue];
    }
    return self;
}
@end
