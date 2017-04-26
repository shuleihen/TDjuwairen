//
//  GradeCommentModel.m
//  TDjuwairen
//
//  Created by zdy on 2017/1/16.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "GradeCommentModel.h"
#import "NSString+Emoji.h"

@implementation GradeCommentModel
- (id)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        _avatar = dict[@"userinfo_facemin"];
        _userName = dict[@"user_nickname"];
        _content = [dict[@"review_content"] stringByReplacingEmojiCheatCodesWithUnicode];
        _createTime = dict[@"review_time"];
        _grade = dict[@"user_score"];
        self.reviewId = dict[@"review_id"];
        self.guessRate = dict[@"guess_rate"];
        
        NSArray *array = dict[@"reply_list"];
        NSMutableArray *replyArray = [NSMutableArray arrayWithCapacity:array.count];
        
        if (array.count) {
            for (NSDictionary *dic in array) {
                GradeCommentReplyModel *model = [[GradeCommentReplyModel alloc] initWithDict:dic];
                [replyArray addObject:model];
            }
        }
        self.replyList = replyArray;
    }
    return self;
}
@end
