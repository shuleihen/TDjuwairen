//
//  SQTopicModel.h
//  CommentDemo
//
//  Created by suqianghotel on 16/8/21.
//  Copyright © 2016年 suqianghotel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQTopicModel : NSObject
@property (nonatomic,copy) NSString *commentId;
@property(nonatomic, copy) NSString *icon;
@property(nonatomic, copy) NSString *userId;
@property(nonatomic, copy) NSString *userName;
@property(nonatomic, copy) NSString *content;
@property(nonatomic, copy) NSString *dateTime;
@property (nonatomic, copy) NSString *parentId;
@property (nonatomic, assign) BOOL isSelf;
@property(nonatomic, assign, getter = isExpanded) BOOL expanded;
@property(nonatomic, strong) NSMutableArray *commentModels;

//** 直播正文 评论头像*/
@property (nonatomic, copy) NSString *user_icon;

//** 评论内容*/
@property (nonatomic, copy) NSString *roomcomment_text;

//** 评论时间*/
@property (nonatomic, copy) NSString *roomcomment_ptime;

- (id)initWithDict:(NSDictionary *)dict;
@end
