//
//  AliveRoomMasterModel.m
//  TDjuwairen
//
//  Created by zdy on 2017/3/10.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveRoomMasterModel.h"

@implementation AliveRoomMasterModel
- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.masterNickName = dict[@"user_nickname"];
        self.roomInfo = dict[@"room_info"];
        self.sex = dict[@"userinfo_sex"];
        self.avatar = dict[@"userinfo_facemin"];
        self.attenNum = dict[@"atten_num"];
        self.fansNum = dict[@"fans_num"];
        self.level = [dict[@"atten_level"] integerValue];
        self.isMaster = [dict[@"is_master"] boolValue];
        self.isAtten = [dict[@"has_atten"] boolValue];
        self.canModifyRoomCover = [dict[@"is_upload_cover"] boolValue];
        self.guessRate = dict[@"guess_rate"];
        self.city = dict[@"address"];
        self.roomInfo = dict[@"room_info"];
        self.roomCover = dict[@"room_cover"];
    }
    
    return self;
}
@end
