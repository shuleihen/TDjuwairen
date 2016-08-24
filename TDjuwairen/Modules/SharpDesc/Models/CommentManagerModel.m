//
//  CommentManagerModel.m
//  TDjuwairen
//
//  Created by 团大 on 16/8/20.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "CommentManagerModel.h"

@implementation CommentManagerModel

+(CommentManagerModel *)getInstanceWithDictionary:(NSDictionary *)dic
{
    CommentManagerModel *model = [[CommentManagerModel alloc]init];
    model.userinfo_facesmall = dic[@"userinfo_facesmall"];
    model.user_nickname = dic[@"user_nickname"];
    
    NSString *str = dic[@"sharpcomment_ptime"];
    NSTimeInterval time = [str doubleValue];
    NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    model.sharpcomment_ptime = [dateFormatter stringFromDate:detaildate];
    model.sharpcomment_text = dic[@"sharpcomment_text"];
    model.sharp_pic280 = dic[@"sharp_pic280"];
    model.sharp_title = dic[@"sharp_title"];
    model.sharpcomment_sharpid = dic[@"sharpcomment_sharpid"];
    
    return model;
}

- (NSComparisonResult)compare:(CommentManagerModel *)other
{
    if (self.sharpcomment_ptime.integerValue > other.sharpcomment_ptime.integerValue) {
        return NSOrderedDescending;
    } else if (self.sharpcomment_ptime.integerValue < other.sharpcomment_ptime.integerValue) {
        return NSOrderedAscending;
    } else {
        return NSOrderedSame;
    }
}

@end
