//
//  CommentsModel.m
//  TDjuwairen
//
//  Created by 团大 on 16/6/2.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "CommentsModel.h"

@implementation CommentsModel

+(CommentsModel *)getInstanceWithDictionary:(NSDictionary *)dic
{
    CommentsModel *model = [[CommentsModel alloc]init];
    model.user_id = dic[@"user_id"];
    model.user_headImg = dic[@"userinfo_facesmall"];
    model.user_nickName = dic[@"user_nickname"];
    model.sharpcomment_id = dic[@"sharpcomment_id"];
    model.sharpcomment_userid = dic[@"sharpcomment_userid"];
    NSString *str = dic[@"sharpcomment_ptime"];
    NSTimeInterval time = [str doubleValue];
    NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    model.commentTime = [dateFormatter stringFromDate:detaildate];
    model.comment = dic[@"sharpcomment_text"];
    return model;
}

@end
