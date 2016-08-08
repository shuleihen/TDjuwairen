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

@property (nonatomic,copy) NSString *comment_goodnum;//好评

@property (nonatomic,copy) NSString *sharpcomment_id;//调研点评id

@property (nonatomic,copy) NSString *sharpcomment;//调研点评内容

@property (nonatomic,copy) NSString *sharpcomment_userid;//调研点评作者的id

@property (nonatomic,copy) NSString *viewcomment_id;//观点点评id

@property (nonatomic,copy) NSString *viewcomment;//观点点评内容

@property (nonatomic,copy) NSString *viewcomment_userid;//观点点评作者

@property (nonatomic,copy) NSString *viewcommentTime;//点评时间

@property (nonatomic,strong) NSArray *secondArr;

+ (CommentsModel *)getInstanceWithDictionary:(NSDictionary *)dictionary;


@end
