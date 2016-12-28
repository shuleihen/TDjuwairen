//
//  GuessCommentModel.h
//  TDjuwairen
//
//  Created by zdy on 2016/12/27.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GuessCommentModel : NSObject
@property (nonatomic, copy) NSString *commentId;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userAvatar;
@property (nonatomic, copy) NSString *addTime;
@property (nonatomic, copy) NSString *parentId;
@property (nonatomic, assign) BOOL isSelf;
@property (nonatomic, strong) NSMutableArray *remarks;

- (id)initWithDict:(NSDictionary *)dict;
@end
