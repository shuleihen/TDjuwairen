//
//  RecordModel.m
//  TDjuwairen
//
//  Created by 团大 on 2016/11/23.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "RecordModel.h"

@implementation RecordModel

+ (RecordModel *)getInstanceWithDic:(NSDictionary *)dic
{
    RecordModel *model = [[RecordModel alloc] init];
    model.record_id = dic[@"record_id"];
    model.record_item = dic[@"record_item"];
    model.record_itemid = dic[@"record_itemid"];
    model.record_keynum = dic[@"record_keynum"];
    model.record_time = dic[@"record_time"];
    model.record_type = [dic[@"record_type"] integerValue];
    
    return model;
}


- (NSComparisonResult)compare:(RecordModel *)other
{
    if (self.record_time.integerValue > other.record_time.integerValue) {
        return NSOrderedDescending;
    } else if (self.record_time.integerValue < other.record_time.integerValue) {
        return NSOrderedAscending;
    } else {
        return NSOrderedSame;
    }
}

- (NSString *)typeString {
    NSString *str = @"";
    
    switch (self.record_type) {
        case 1:
            str = @"购买钥匙";
            break;
        case 2:
            str = @"充值VIP赠送";
            break;
        case 3:
            str = @"调研赠送";
            break;
        case 4:
            str = @"比谁准竞猜";
            break;
        case 5:
            str = @"股票池收入";
            break;
        case 6:
            str = @"后台赠送";
            break;
        case 7:
            str = @"解锁调研";
            break;
        case 8:
            str = @"解锁股票池";
            break;
        case 9:
            str = @"比谁准竞猜";
            break;
        case 10:
            str = @"兑换奖品";
            break;
        case 11:
            str = @"比谁准竞猜无效退还";
            break;
        case 12:
            str = @"猜红绿获胜";
            break;
        case 13:
            str = @"系统处理";
            break;
        case 14:
            str = @"后台回收钥匙";
            break;
        case 15:
            str = @"用户注册赠送";
            break;
        case 16:
        case 17:
            str = @"指数竞猜";
            break;
            
        default:
            break;
    }
    
    return str;
}
@end
