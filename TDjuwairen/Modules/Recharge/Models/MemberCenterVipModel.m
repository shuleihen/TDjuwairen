//
//  MemberCenterVipModel.m
//  TDjuwairen
//
//  Created by zdy on 2017/8/29.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "MemberCenterVipModel.h"

@implementation MemberCenterVipModel
- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.pointsNum = dict[@"point_num"];
        self.level = [dict[@"vip_type"] integerValue];
        self.price = dict[@"vip_price"];
        self.keyNum = dict[@"key_num"];
        self.validTime = dict[@"valid_time"];
        self.vipId = dict[@"product_id"];
    }
    return self;
}

- (NSString *)levelString {
    NSString *string = @"";
    switch (self.level) {
        case kUserLevelGold:
            string = @"黄金会员";
            break;
        case kUserLevelBronze:
            string = @"青铜会员";
            break;
        case kUserLevelSilver:
            string = @"白银会员";
            break;
        default:
            break;
    }
    return string;
}
@end
