//
//  WalletRecordModel.m
//  TDjuwairen
//
//  Created by zdy on 2017/8/14.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "IntegralRecordModel.h"

@implementation IntegralRecordModel
- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.recordId = dict[@"record_id"];
        self.title = dict[@"record_title"];
        self.moth = dict[@"record_month"];
        self.time = dict[@"record_time"];
        self.integral = [dict[@"record_points_num"] integerValue];
    }
    return self;
}
@end
