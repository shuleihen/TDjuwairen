//
//  GradeCommentReplyModel.m
//  TDjuwairen
//
//  Created by zdy on 2017/4/22.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "GradeCommentReplyModel.h"
#import "NSString+Emoji.h"

@implementation GradeCommentReplyModel
- (id)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.avatar = dict[@"userinfo_facemin"];
        self.nickName = dict[@"user_nickname"];
        self.replyContent = [dict[@"reply_content"] stringByReplacingEmojiCheatCodesWithUnicode];
        self.replyTime = dict[@"reply_time"];
    }
    return self;
}
@end
