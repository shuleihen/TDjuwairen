//
//  SysMessageListModel.m
//  TDjuwairen
//
//  Created by zdy on 2017/7/18.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "SysMessageListModel.h"

/*
 msgcontent html 富文本格式
 <img src=\"https://juwairenimg.oss-cn-hangzhou.aliyuncs.com/Ad/userid_20170615163051.jpg?x-oss-process=image/resize,w_750\" height=\"178\"/> </br> <label style=\"font-size: 15px;color: #333333\">abcc  <span style=\"color: #EC9C1D\">daddda</span>csd</label>
 */

@implementation SysMessageListModel

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.msgId = dict[@"message_id"];
        self.msgContent = dict[@"message_content"];
        self.msgTime = dict[@"message_time"];
        self.msgTitle = dict[@"message_title"];
        self.msgType = [dict[@"message_type"] integerValue];
        self.msgLink = dict[@"message_link"];
        self.msgLinkType = [dict[@"message_link_type"] integerValue];
        self.msgContentType = [dict[@"message_content_type"] integerValue];
    }
    return self;
}

- (NSString *)typeString {
    NSString *string;
    // 1表示活动，2表示钥匙奖励 ，3表示 用户反馈，4表示兑换奖品
    switch (self.msgType) {
        case 1:
            string = @"活动";
            break;
        case 2:
            string = @"钥匙奖励";
            break;
        case 3:
            string = @"用户反馈";
            break;
        case 4:
            string = @"兑换奖品";
            break;
            
        default:
            break;
    }
    
    return string;
}
@end
