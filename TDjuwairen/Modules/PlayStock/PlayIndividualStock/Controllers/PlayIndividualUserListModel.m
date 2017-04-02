//
//  PlayIndividualUserListModel.m
//  TDjuwairen
//
//  Created by ZYP-MAC on 17/3/31.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "PlayIndividualUserListModel.h"

@implementation PlayIndividualUserListModel
- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.is_winner = [dict[@"is_winner"] boolValue];
        self.is_points_closet = dict[@"is_points_closet"];
        self.userinfo_facemin = dict[@"userinfo_facemin"];
        self.user_nickname = dict[@"user_nickname"];
        self.is_up = dict[@"is_up"];
        self.is_self = dict[@"is_self"];
        self.item_points = [NSString stringWithFormat:@"%@",dict[@"item_points"]];
    }
    
    return self;
}
@end
