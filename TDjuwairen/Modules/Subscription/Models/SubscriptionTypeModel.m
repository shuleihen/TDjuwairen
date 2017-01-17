//
//  SubscriptionTypeModel.m
//  TDjuwairen
//
//  Created by zdy on 2017/1/17.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "SubscriptionTypeModel.h"

@implementation SubscriptionTypeModel
- (id)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        _subType = [dict[@"sub_type"] integerValue];
        _keyNum = [dict[@"key_num"] integerValue];
        _subDesc = dict[@"sub_desc"];
    }
    return self;
}
@end
