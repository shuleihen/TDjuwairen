//
//  SurveyListModel.m
//  TDjuwairen
//
//  Created by 团大 on 16/5/16.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "SurveyListModel.h"

@implementation SurveyListModel

+(SurveyListModel *)getInstanceWithDictionary:(NSDictionary *)dic
{
    SurveyListModel *model = [[SurveyListModel alloc]init];
    model.sharp_id = dic[@"sharp_id"];
    model.sharp_title = dic[@"sharp_title"];
    model.sharp_desc = dic[@"sharp_desc"];
    model.sharp_imgurl = dic[@"sharp_pic280"];
    model.sharp_wtime = dic[@"sharp_wtime"];
    model.user_facemin = dic[@"userinfo_facesmall"];
    model.user_nickname = dic[@"user_nickname"];
    model.sharp_goodNumber = dic[@"sharp_goodnumbers"];
    model.sharp_commentNumber = [dic[@"sharpcommentNumbers"] intValue];
    return model;
}

- (NSComparisonResult)compare:(SurveyListModel *)other
{
    if (self.sharp_wtime.integerValue > other.sharp_wtime.integerValue) {
        return NSOrderedDescending;
    } else if (self.sharp_wtime.integerValue < other.sharp_wtime.integerValue) {
        return NSOrderedAscending;
    } else {
        return NSOrderedSame;
    }
}
@end
