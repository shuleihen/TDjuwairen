//
//  AliveListModel.m
//  TDjuwairen
//
//  Created by zdy on 2017/3/9.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveListModel.h"
#import "NSString+Emoji.h"

@implementation AliveListModel
- (id)initWithDictionary:(NSDictionary *)dict {
    if (self =  [super init]) {
        self.aliveId = dict[@"alive_id"];
        self.aliveType = [dict[@"alive_type"] integerValue];
        self.aliveImgs = dict[@"alive_img"];
        self.aliveTime = dict[@"alive_time"];
        self.aliveTitle = [dict[@"alive_title"] stringByReplacingEmojiCheatCodesWithUnicode];
        self.masterId = [NSString stringWithFormat:@"%ld",(long)[dict[@"alive_master_id"] integerValue]];
        self.masterNickName = dict[@"user_nickname"];
        self.masterAvatar = dict[@"userinfo_facemin"];
        self.commentNum = [dict[@"alive_comment_num"] integerValue];
        self.isLike = [dict[@"alive_has_assess"] boolValue];
        self.likeNum = [dict[@"alive_assess_num"] integerValue];
        self.shareNum = [dict[@"alive_share_num"] integerValue];
        self.shareUrl = SafeValue(dict[@"alive_share_url"]);
        self.isOfficial = [dict[@"is_official"] boolValue];
        self.isAttend = [dict[@"is_attend"] boolValue];
        self.isSelf = [dict[@"is_self"] boolValue];
        self.collectedId = dict[@"collect_id"];
        self.visitNum = [dict[@"alive_visitnum"] integerValue];
        
        BOOL isforward = [dict[@"is_forward"] boolValue];
        self.isForward = isforward;
        
        // 转发
        if (isforward) {
            self.forwardImgs = dict[@"forward_imgs"];
            self.forwardUsers = dict[@"forward_users"];
            
            id forward = dict[@"forward_info"];
            if ([forward isKindOfClass:[NSArray class]]) {
                self.forwardModel = [[AliveListForwardModel alloc] initWithArray:forward];
            } else if ([forward isKindOfClass:[NSDictionary class]]) {
                AliveListModel *model = [[AliveListModel alloc] initWithDictionary:forward];
                
                self.forwardModel = [[AliveListForwardModel alloc] init];
                self.forwardModel.forwardList = @[model];
            }
        }
        
        // 额外信息
        NSDictionary *extraDict = dict[@"alive_extra"];
        if (self.aliveType == kAlivePlayStock) {
            self.extra = [[AliveListPlayStockExtra alloc] initWithDictionary:extraDict];
        } else if (self.aliveType == kAliveAd) {
            self.extra = [[AliveListAdExtra alloc] initWithDictionary:extraDict];
        } else if (self.aliveType == kAlivePosts) {
            self.extra = [[AliveListPostExtra alloc] initWithDictionary:extraDict];
        } else if (self.aliveType == kAliveStockPool ||
                   self.aliveType == kAliveStockPoolRecord) {
            self.extra = [[AliveListStockPoolExtra alloc] initWithDictionary:extraDict];
        } else if (self.aliveType == kAliveSurvey ||
                   self.aliveType == kAliveVideo ||
                   self.aliveType == kAliveHot ||
                   self.aliveType == kAliveDeep){
            self.extra = [[AliveListExtra alloc] initWithDictionary:extraDict];
        } else if (self.aliveType == kAliveVisitCard) {
            self.extra = [[AliveListVisitCardExtra alloc] initWithDictionary:extraDict];
        } else {
            self.extra = extraDict;
        }
        
    }
    return self;
}

- (BOOL)isCollection {
    return (self.collectedId.length>0)?YES:NO;
}
@end
