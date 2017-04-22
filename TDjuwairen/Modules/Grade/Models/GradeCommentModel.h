//
//  GradeCommentModel.h
//  TDjuwairen
//
//  Created by zdy on 2017/1/16.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GradeCommentReplyModel.h"

@interface GradeCommentModel : NSObject
@property (nonatomic, copy) NSString *reviewId;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *grade;
@property (nonatomic, strong) NSArray *replyList;
@property (nonatomic, strong) NSNumber *guessRate;

- (id)initWithDict:(NSDictionary *)dict;
@end
