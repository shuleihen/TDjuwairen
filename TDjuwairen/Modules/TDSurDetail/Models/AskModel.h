//
//  AskModel.h
//  TDjuwairen
//
//  Created by 团大 on 2016/11/10.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AskModel : NSObject

@property (nonatomic,strong) NSMutableArray *ans_list;

@property (nonatomic,copy) NSString *surveyask_content;

@property (nonatomic,copy) NSString *surveyask_isdel;

@property (nonatomic,copy) NSString *surveyask_id;

@property (nonatomic,copy) NSString *surveyask_userid;

@property (nonatomic,copy) NSString *surveyask_addtime;

@property (nonatomic,copy) NSString *surveyask_code;

@property (nonatomic,copy) NSString *user_nickname;

@property (nonatomic,copy) NSString *userinfo_facemin;

@property (nonatomic,copy) NSString *surveyask_isanswer;

+ (AskModel *)getInstanceWithDictionary:(NSDictionary *)dic;

@end
