//
//  WalletRecordModel.m
//  TDjuwairen
//
//  Created by zdy on 2017/8/14.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "WalletRecordModel.h"

@implementation WalletRecordModel
- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.recordId = dict[@"record_id"];
        self.title = dict[@"record_title"];
        self.moth = dict[@"record_month"];
        self.time = dict[@"record_time"];
        self.key = [dict[@"record_keynum"] integerValue];
    }
    return self;
}
@end
