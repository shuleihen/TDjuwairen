//
//  PSIndividualUserListModel.m
//  TDjuwairen
//
//  Created by ZYP-MAC on 17/3/31.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "PSIndividualUserListModel.h"

@implementation PSIndividualUserListModel
- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.is_winner = [dict[@"is_winner"] boolValue];
        self.is_points_closet = [dict[@"is_points_closet"] boolValue];
        self.userinfo_facemin = dict[@"userinfo_facemin"];
        self.user_nickname = dict[@"user_nickname"];
        self.is_up = [dict[@"is_up"] boolValue];
        self.is_self = [dict[@"is_self"] boolValue];
        self.item_points = dict[@"item_points"];
    }
    
    return self;
}

- (id)initWithDetailDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.is_winner = [dict[@"is_winner"] boolValue];
        self.userinfo_facemin = dict[@"userinfo_facemin"];
        self.user_nickname = dict[@"user_nickname"];
        self.is_self = [dict[@"is_self"] boolValue];
        self.item_points = dict[@"item_points"];
        self.isStarter = [dict[@"is_starter"] boolValue];
        self.winKeyNum = [dict[@"win_keynum"] integerValue];
        self.rank = [dict[@"item_rank"] integerValue];
        self.addTime = dict[@"item_addtime"];
    }
    
    return self;
}
@end
