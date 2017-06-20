//
//  VideoInfoModel.m
//  TDjuwairen
//
//  Created by zdy on 2017/6/20.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "VideoInfoModel.h"

@implementation VideoInfoModel
- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.avatar = dict[@"userinfo_facemin"];
        self.cover = dict[@"com_video_cover"];
        self.nickName = dict[@"user_nickname"];
        self.content = dict[@"com_video_content"];
        self.videoSrc = dict[@"com_video_src"];
        self.title = dict[@"com_video_title"];
        self.shareUrl = dict[@"share_url"];
        self.shareNum = dict[@"share_num"];
        self.visitNum = dict[@"com_video_visitnum"];
        self.isUnlock = [dict[@"is_unlock"] boolValue];
    }
    return self;
}
@end
