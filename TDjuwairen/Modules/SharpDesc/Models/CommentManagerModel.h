//
//  CommentManagerModel.h
//  TDjuwairen
//
//  Created by 团大 on 16/8/20.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentManagerModel : NSObject

@property (nonatomic,copy) NSString *surveycomment_comment;
@property (nonatomic,copy) NSString *survey_title;
@property (nonatomic,copy) NSString *company_code;
@property (nonatomic,copy) NSString *user_nickname;
@property (nonatomic,copy) NSString *userinfo_facemin;
@property (nonatomic,copy) NSString *survey_cover;
@property (nonatomic,copy) NSString *surveycomment_addtime;

+(CommentManagerModel *)getInstanceWithDictionary:(NSDictionary *)dic;

@end
