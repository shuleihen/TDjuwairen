//
//  AnsModel.m
//  TDjuwairen
//
//  Created by 团大 on 2016/11/10.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "AnsModel.h"
#import "NSString+Emoji.h"

@implementation AnsModel

+ (AnsModel *)getInstanceWithDictionary:(NSDictionary *)dic
{
    AnsModel *model = [[AnsModel alloc] init];
    
    model.surveyanswer_isdel = dic[@"surveyanswer_isdel"];
    model.isliked = [dic[@"isliked"] boolValue];
    model.surveyanswer_id = dic[@"surveyanswer_id"];
    model.user_nickname = dic[@"user_nickname"];
    model.surveyanswer_goodnums = dic[@"surveyanswer_goodnums"];
    model.surveyanswer_content = [dic[@"surveyanswer_content"] stringByReplacingEmojiCheatCodesWithUnicode];
    model.surveyanswer_userid = dic[@"surveyanswer_userid"];
    model.userinfo_facemin = dic[@"userinfo_facemin"];
    model.surveyanswer_askid = dic[@"surveyanswer_askid"];
    model.surveyanswer_addtime = dic[@"surveyanswer_addtime"];
    return model;
}

@end
