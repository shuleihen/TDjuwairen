//
//  AliveListModel.m
//  TDjuwairen
//
//  Created by zdy on 2017/3/9.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveListModel.h"

@implementation AliveListModel
- (id)initWithDictionary:(NSDictionary *)dict {
    if (self =  [super init]) {
        self.aliveId = dict[@"alive_id"];
        self.aliveType = [dict[@"alive_type"] integerValue];
        self.aliveImgs = dict[@"alive_img"];
        self.aliveTime = dict[@"alive_time"];
        self.aliveTitle = dict[@"alive_title"];
        self.masterId = dict[@"alive_master_id"];
        self.masterNickName = dict[@"user_nickname"];
        self.masterAvatar = dict[@"userinfo_facemin"];
        self.commentNum = [dict[@"alive_comment_num"] integerValue];
        self.isLike = [dict[@"alive_has_assess"] boolValue];
        self.likeNum = [dict[@"alive_assess_num"] integerValue];
        self.shareNum = [dict[@"alive_share_num"] integerValue];
        self.shareUrl = SafeValue(dict[@"alive_share_url"]);
        self.aliveTags = dict[@"alive_com_tag"];
        
        BOOL isforward = [dict[@"is_forward"] boolValue];
        self.isForward = isforward;
        
        if (isforward) {
            NSDictionary *d = dict[@"forward_info"];
            self.forwardModel = [[AliveListForwardModel alloc] initWithDictionary:d];
        }
    }
    return self;
}
@end
