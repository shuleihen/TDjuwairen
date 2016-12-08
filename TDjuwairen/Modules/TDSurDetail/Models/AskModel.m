//
//  AskModel.m
//  TDjuwairen
//
//  Created by 团大 on 2016/11/10.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "AskModel.h"
#import "AnsModel.h"

@implementation AskModel

+ (AskModel *)getInstanceWithDictionary:(NSDictionary *)dic
{
    AskModel *model = [[AskModel alloc] init];
    
    NSArray *ans_list = dic[@"ans_list"];
    model.ans_list = [NSMutableArray array];
    for (NSDictionary *dic in ans_list) {
        AnsModel *ansmodel = [AnsModel getInstanceWithDictionary:dic];
        [model.ans_list addObject:ansmodel];
    }
    model.is_author = [dic[@"is_author"] boolValue];
    model.surveyask_content = dic[@"surveyask_content"];
    model.surveyask_isdel = dic[@"surveyask_isdel"];
    model.surveyask_id = dic[@"surveyask_id"];
    model.surveyask_userid = dic[@"surveyask_userid"];
    model.surveyask_addtime = dic[@"surveyask_addtime"];
    model.surveyask_code = dic[@"surveyask_code"];
    model.user_nickname = dic[@"user_nickname"];
    model.userinfo_facemin = dic[@"userinfo_facemin"];
    model.surveyask_isanswer = dic[@"surveyask_isanswer"];
    
    return model;
}

@end
