//
//  SharpModel.m
//  TDjuwairen
//
//  Created by zdy on 16/7/28.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "SharpModel.h"

@implementation SharpModel
+ (id)sharpWithDictionary:(NSDictionary *)dict
{
    SharpModel *sharp = [[SharpModel alloc] init];
    //    sharp.sharpId
    sharp.sharpContent = dict[@"sharp_content_url"];
    sharp.sharpTypeId = [dict[@"sharp_typeid"] intValue];
    sharp.sharpTitle = dict[@"sharp_title"];
    sharp.sharpDesc = dict[@"sharp_desc"];
    sharp.sharpUserName = dict[@"user_nickname"];
    sharp.sharpUserIcon = dict[@"userinfo_facesmall"];
    sharp.sharpWtime = dict[@"sharp_wtime"];
    sharp.sharpCommentNumbers = [dict[@"sharpcommentNumbers"] intValue];
    sharp.sharpIsCollect = [dict[@"sharp_iscollect"] boolValue];
    sharp.sharpIsOriginal = [dict[@"sharp_isoriginal"] boolValue];
    sharp.sharpThumbnail = dict[@"sharp_pic280"];
    sharp.sharpTags = dict[@"tags"];
    return sharp;
}
@end
