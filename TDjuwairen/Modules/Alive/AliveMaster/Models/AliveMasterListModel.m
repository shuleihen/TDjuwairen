//
//  AliveMasterListModel.m
//  TDjuwairen
//
//  Created by zdy on 2017/3/9.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveMasterListModel.h"

@implementation AliveMasterListModel
- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.masterId = dict[@"master_id"];
        self.masterNickName = dict[@"user_nickname"];
        self.avatar = dict[@"user_facesmall"];
        self.attenNum = dict[@"userinfo_atten_num"];
        self.level = [dict[@"user_atten_level"] integerValue];
        self.isAtten = [dict[@"has_atten"] boolValue];
    }
    return self;
}
@end
