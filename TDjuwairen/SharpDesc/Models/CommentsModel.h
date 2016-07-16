//
//  CommentsModel.h
//  TDjuwairen
//
//  Created by 团大 on 16/6/2.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentsModel : NSObject

@property (nonatomic,copy) NSString *user_id;

@property (nonatomic,copy) NSString *user_headImg;

@property (nonatomic,copy) NSString *user_nickName;

@property (nonatomic,copy) NSString *commentTime;//点评时间

@property (nonatomic,copy) NSString *sharpcomment_id;//点评id

@property (nonatomic,copy) NSString *comment;//点评内容

@property (nonatomic,copy) NSString *sharpcomment_userid;//点评作者的id

+ (CommentsModel *)getInstanceWithDictionary:(NSDictionary *)dictionary;


@end
