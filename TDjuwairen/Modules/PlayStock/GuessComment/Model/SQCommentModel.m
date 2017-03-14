//
//  SQCommentModel.m
//  CommentDemo
//
//  Created by suqianghotel on 16/8/21.
//  Copyright © 2016年 suqianghotel. All rights reserved.
//

#import "SQCommentModel.h"
#import "NSString+Emoji.h"

@implementation SQCommentModel
- (id)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        _commentId = dict[@"comment_id"];
        _content = [dict[@"comment_text"] stringByReplacingEmojiCheatCodesWithUnicode];
        _userId = dict[@"comment_userid"];
        _userName = dict[@"user_nickname"];
        _icon = dict[@"userinfo_facemin"];
        _dateTime = dict[@"comment_ptime"];
        _parentId = dict[@"comment_ppid"];
        _isSelf = [dict[@"is_self"] boolValue];
        
        _roomremark_text = [SafeValue(dict[@"roomremark_text"]) stringByReplacingEmojiCheatCodesWithUnicode];
    }
    return self;
}

- (NSString *)all
{
    if (_all == nil) {
        
        if (self.to && self.to.length > 0) {
            _all = [NSString stringWithFormat:@"%@回复%@: %@", self.from, self.to, self.content];

        }
        else
        {
            _all = [NSString stringWithFormat:@"%@: %@", self.from, self.content];

        }
        
    }
    return _all;
}

@end
