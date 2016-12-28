//
//  GuessCommentModel.m
//  TDjuwairen
//
//  Created by zdy on 2016/12/27.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "GuessCommentModel.h"

@implementation GuessCommentModel
- (id)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.commentId = dict[@"comment_id"];
        self.content = dict[@"commtent_text"];
        self.userId = dict[@"comment_userid"];
        self.userName = dict[@"user_nickname"];
        self.userAvatar = dict[@"userinfo_facemin"];
        self.addTime = dict[@"comment_ptime"];
        self.parentId = dict[@"comment_ppid"];
        self.isSelf = [dict[@"is_self"] boolValue];
        
        NSArray *list = dict[@"remark"];
        if ([list count]) {
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:[list count]];
            for (NSDictionary *dic in list) {
                GuessCommentModel *sub = [[GuessCommentModel alloc] initWithDict:dic];
                [array addObject:sub];
            }
            self.remarks = array;
        }
    }
    return self;
}
@end
