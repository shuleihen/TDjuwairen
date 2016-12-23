//
//  StockCommentModel.m
//  TDjuwairen
//
//  Created by zdy on 2016/11/30.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "StockCommentModel.h"

@implementation StockCommentModel

+ (StockCommentModel *)getInstanceWithDictionary:(NSDictionary *)dic {
    StockCommentModel *model = [[StockCommentModel alloc] init];
    model.commentId = dic[@"surveycomment_id"];
    model.userId = dic[@"surveycomment_userid"];
    model.userName = dic[@"user_nickname"];
    model.userAvatar = dic[@"userinfo_facemin"];
    model.isLiked = [dic[@"isliked"] boolValue];
    model.content = dic[@"surveycomment_comment"];
    model.stockId = dic[@"surveycomment_code"];
    model.goodNums = [dic[@"surveycomment_goodnums"] integerValue];
    model.type = [dic[@"surveycomment_type"] integerValue];
    model.createTime = dic[@"surveycomment_addtime"];
    return model;
}
@end
