//
//  ViewPointListModel.m
//  TDjuwairen
//
//  Created by 团大 on 16/7/25.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "ViewPointListModel.h"

@implementation ViewPointListModel

+ (ViewPointListModel *)getInstanceWithDictionary:(NSDictionary *)dic
{
    ViewPointListModel *model = [[ViewPointListModel alloc]init];
    model.view_id = dic[@"view_id"];
    model.view_title = dic[@"view_title"];
    model.user_facemin = dic[@"userinfo_facesmall"];
    model.user_nickname = dic[@"view_author"];
    NSString *str = dic[@"view_addtime"];
    NSTimeInterval time = [str doubleValue];
    NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    model.view_wtime = [dateFormatter stringFromDate:detaildate];
    
    model.view_isoriginal = dic[@"view_isoriginal"];
    
    return model;
}

- (NSComparisonResult)compare:(ViewPointListModel *)other
{
    if (self.view_wtime.integerValue > other.view_wtime.integerValue) {
        return NSOrderedDescending;
    } else if (self.view_wtime.integerValue < other.view_wtime.integerValue) {
        return NSOrderedAscending;
    } else {
        return NSOrderedSame;
    }
}

@end
