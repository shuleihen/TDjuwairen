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
    model.user_headImg = dic[@"userinfo_facemedium"];
    model.user_nickName = dic[@"user_nickname"];
    model.comment_goodnum = dic[@"comment_goodnum"];
    model.commentStatus = dic[@"commentassessStatus"];

    NSString *str = dic[@"sharpcomment_ptime"];
    NSTimeInterval time = [str doubleValue];
    NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM-dd HH:mm:ss"];
    model.commentTime = [dateFormatter stringFromDate:detaildate];
    
    NSString *viewstr = dic[@"viewcomment_ptime"];
    NSTimeInterval viewtime = [viewstr doubleValue];
    NSDate *viewdetaildate = [NSDate dateWithTimeIntervalSince1970:viewtime];
    NSDateFormatter *viewdateFormatter = [[NSDateFormatter alloc]init];
    [viewdateFormatter setDateFormat:@"MM-dd HH:mm:ss"];
    model.viewcommentTime = [viewdateFormatter stringFromDate:viewdetaildate];
    
    model.sharpcomment_id = dic[@"sharpcomment_id"];
    model.sharpcomment_userid = dic[@"sharpcomment_userid"];
    model.sharpcomment = dic[@"sharpcomment_text"];
    
    model.viewcomment_id = dic[@"viewcomment_id"];
    model.viewcomment_pid = dic[@"viewcomment_pid"];
    model.viewcomment_userid = dic[@"viewcomment_userid"];
    model.viewcomment = dic[@"viewcomment_text"];
    
    model.secondArr = dic[@"pcomment"];
    
    return model;
}



@end
