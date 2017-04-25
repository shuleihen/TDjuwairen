//
//  AnsModel.m
//  TDjuwairen
//
//  Created by 团大 on 2016/11/10.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "AnsModel.h"
#import "NSString+Emoji.h"

@implementation AnsModel

- (id)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.answerId = dict[@"answer_id"];
        self.ansContent = [dict[@"answer_content"] stringByReplacingEmojiCheatCodesWithUnicode];
        self.ansUserName = dict[@"user_nickname"];
        self.ansUserAvatar = dict[@"userinfo_facemin"];
        self.ansLikeNum = dict[@"answer_likenum"];
        self.isLiked = [dict[@"isliked"] boolValue];
    }
    
    return self;
}

@end
