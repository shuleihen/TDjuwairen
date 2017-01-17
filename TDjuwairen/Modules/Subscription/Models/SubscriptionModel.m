//
//  SubscriptionModel.m
//  TDjuwairen
//
//  Created by zdy on 2017/1/12.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "SubscriptionModel.h"

@implementation SubscriptionModel
- (id)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        _subTitle = dict[@"subscribe_item"];
        _way = dict[@"subscribe_way"];
        _userName = dict[@"subscribe_real_name"];
        _dateTime = dict[@"subscribe_time"];
        _userEmail = dict[@"subscribe_email"];
    }
    return self;
}
@end
