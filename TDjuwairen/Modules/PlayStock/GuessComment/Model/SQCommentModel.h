//
//  SQCommentModel.h
//  CommentDemo
//
//  Created by suqianghotel on 16/8/21.
//  Copyright © 2016年 suqianghotel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQCommentModel : NSObject
@property (nonatomic, copy) NSString *from;
@property (nonatomic, copy) NSString *to;

@property (nonatomic,copy) NSString *commentId;
@property(nonatomic, copy) NSString *icon;
@property(nonatomic, copy) NSString *userId;
@property(nonatomic, copy) NSString *userName;
@property(nonatomic, copy) NSString *content;
@property(nonatomic, copy) NSString *dateTime;
@property (nonatomic, copy) NSString *parentId;
@property (nonatomic, assign) BOOL isSelf;

@property(nonatomic, copy) NSString *all;

- (id)initWithDict:(NSDictionary *)dict;
@end
