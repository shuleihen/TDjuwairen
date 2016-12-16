//
//  CommentManagerModel.m
//  TDjuwairen
//
//  Created by 团大 on 16/8/20.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "CommentManagerModel.h"

@implementation CommentManagerModel

+(CommentManagerModel *)getInstanceWithDictionary:(NSDictionary *)dic
{
    CommentManagerModel *model = [[CommentManagerModel alloc]init];
    model.surveycomment_comment = dic[@"surveycomment_comment"];
    model.survey_title = dic[@"survey_title"];
    model.company_code = dic[@"company_code"];
    model.company_name = dic[@"company_name"];
    model.user_nickname = dic[@"user_nickname"];
    model.userinfo_facemin = dic[@"userinfo_facemin"];
    model.survey_cover = dic[@"survey_cover"];
    model.surveycomment_addtime = dic[@"surveycomment_addtime"];
    
    return model;
}

@end
