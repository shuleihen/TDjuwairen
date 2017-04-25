//
//  FirmPlatListModel.m
//  TDjuwairen
//
//  Created by deng shu on 2017/4/25.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "FirmPlatListModel.h"

@implementation FirmPlatListModel

- (id)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        _account_status = dict[@"account_status"];
        _plat_id = dict[@"plat_id"];
        _plat_info = dict[@"plat_info"];
        _plat_keynum = dict[@"plat_keynum"];
        _plat_logo = dict[@"plat_logo"];
        _plat_name = dict[@"plat_name"];
        _plat_phone = dict[@"plat_phone"];
        _plat_url = dict[@"plat_url"];
    }
    return self;
}
@end
