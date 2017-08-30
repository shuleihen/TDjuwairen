//
//  StockPoolUnlockModel.m
//  TDjuwairen
//
//  Created by zdy on 2017/8/17.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "StockPoolUnlockModel.h"

@implementation StockPoolUnlockModel
- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.isFree = [dict[@"pool_is_free"] boolValue];
        self.poolSetTip = dict[@"pool_set_tip"];
        self.poolSetDesc = [dict[@"pool_set_desc"] stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
        self.isSubscribe = [dict[@"user_is_subscribe"] boolValue];
        self.isSubscribeExpire = [dict[@"user_subscribe_expire"] boolValue];
        self.isHaveEnoughKey = [dict[@"user_key_enough"] boolValue];
    }
    return self;
}
@end
