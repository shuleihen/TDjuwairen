//
//  SpecialModel.m
//  TDjuwairen
//
//  Created by 团大 on 16/7/26.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "SpecialModel.h"

@implementation SpecialModel

+(SpecialModel *)getInstanceWithDictionary:(NSDictionary *)dic
{
    SpecialModel *model = [[SpecialModel alloc]init];
    model.subject_logo_max = dic[@"subject_logo_max"];
    model.subject_tag = dic[@"subject_tag"];
    model.subject_title = dic[@"subject_title"];
    return model;
}

@end
