//
//  GradeCommentReplyModel.h
//  TDjuwairen
//
//  Created by zdy on 2017/4/22.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GradeCommentReplyModel : NSObject
@property (nonatomic, copy) NSString *replyId;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *replyContent;
@property (nonatomic, copy) NSString *replyTime;

- (id)initWithDict:(NSDictionary *)dict;
@end
