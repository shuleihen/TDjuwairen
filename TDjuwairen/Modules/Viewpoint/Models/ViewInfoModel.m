//
//  ViewInfoModel.m
//  TDjuwairen
//
//  Created by 团大 on 16/8/12.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "ViewInfoModel.h"

@implementation ViewInfoModel


+ (id)viewWithDictionary:(NSDictionary *)dic{
    ViewInfoModel *model = [[ViewInfoModel alloc]init];
    model.is_attention_author = dic[@"is_attention_author"];
    model.is_collection = dic[@"is_collection"];
    model.tagsArr = dic[@"tags"];
    model.view_content_url = dic[@"view_content_url"];
    model.userinfo_facesmall = dic[@"userinfo_facesmall"];
    model.view_addtime = dic[@"view_addtime"];
    model.view_author = dic[@"view_author"];
    model.view_title = dic[@"view_title"];
    model.view_id = dic[@"view_id"];
    return model;
}
@end
