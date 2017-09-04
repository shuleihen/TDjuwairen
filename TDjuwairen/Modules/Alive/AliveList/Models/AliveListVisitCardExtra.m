//
//  AliveListVisitCardExtra.m
//  TDjuwairen
//
//  Created by zdy on 2017/9/4.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveListVisitCardExtra.h"

@implementation AliveListVisitCardExtra
- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.masterId = dict[@"user_id"];
        self.masterNickName = dict[@"user_nickname"];
        self.avatar = dict[@"userinfo_facemin"];
        self.desc = dict[@"desc"];
    }
    
    return self;
}

@end
