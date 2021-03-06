//
//  SQTopicModel.m
//  CommentDemo
//
//  Created by suqianghotel on 16/8/21.
//  Copyright © 2016年 suqianghotel. All rights reserved.
//

#import "SQTopicModel.h"
#import "SQCommentModel.h"
#import "NSString+Emoji.h"

@implementation SQTopicModel
- (id)init {
    if (self = [super init]) {
        _commentModels = [NSMutableArray array];
    }
    return self;
}

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
        
        _user_icon = dict[@"user_facesmall"];
        _roomcomment_text = dict[@"roomcomment_text"];
        _roomcomment_ptime = dict[@"roomcomment_ptime"];
        _roomCommentId = dict[@"roomcomment_id"];
        NSArray *roomList = dict[@"remark_list"];
        NSMutableArray *roomArray = [NSMutableArray arrayWithCapacity:[roomList count]];
        
        for (NSDictionary *dic in roomList) {
            SQCommentModel *sub = [[SQCommentModel alloc] initWithDict:dic];
            [roomArray addObject:sub];
        }
        _roomCommentModels = roomArray;
        
        
        NSArray *list = dict[@"remark"];
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:[list count]];
        
        for (NSDictionary *dic in list) {
            SQCommentModel *sub = [[SQCommentModel alloc] initWithDict:dic];
            [array addObject:sub];
        }
        _commentModels = array;
    }
    return self;
}
@end
