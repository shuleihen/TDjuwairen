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


- (NSString *)account_statusStr {
    NSString *str = @"";
    switch ([self.account_status integerValue]) {
        case 0:
            str = @"立即开户";
            break;
        case 1:
            str = @"核对中";
            break;
        case 2:
            str = @"已开户";
            break;
        case 3:
            str = @"开户失败";
            break;
            
        default:
            break;
    }
    return str;
}

@end
