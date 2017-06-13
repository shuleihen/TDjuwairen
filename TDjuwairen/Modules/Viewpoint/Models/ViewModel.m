//
//  ViewModel.m
//  TDjuwairen
//
//  Created by 团大 on 16/9/21.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "ViewModel.h"

@implementation ViewModel

+ (id)shareWithDictionary:(NSDictionary *)dic
{
    ViewModel *model = [[ViewModel alloc]init];
    

    NSString *str = dic[@"view_addtime"];
    NSTimeInterval time = [str doubleValue];
    NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    model.view_addtime = [dateFormatter stringFromDate:detaildate];
    
    model.view_userid = dic[@"view_userid"];
    model.view_author = dic[@"view_author"];
    model.userinfo_facesmall = dic[@"userinfo_facesmall"];
    
    model.view_content_url = dic[@"view_content_url"];
    model.view_id = dic[@"view_id"];
    model.view_title = dic[@"view_title"];
    model.tags = dic[@"tags"];
    model.view_thumb = dic[@"view_thumb"];
    model.view_isCollected = [dic[@"is_collection"] boolValue];
    model.view_isAtten = [dic[@"is_attention_author"] boolValue];
    model.view_isOriginal = [dic[@"view_isoriginal"] boolValue];
    model.view_isLike = [dic[@"view_has_assess"] boolValue];
    model.view_visintnum = dic[@"view_visitnum"];
    model.view_share_url = dic[@"view_share_url"];
    return model;
}

@end

