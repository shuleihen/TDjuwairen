//
//  OrderModel.m
//  TDjuwairen
//
//  Created by 团大 on 2016/11/22.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "OrderModel.h"

@implementation OrderModel

+ (OrderModel *)getInstanceFromDic:(NSDictionary *)dic
{
    OrderModel *model = [[OrderModel alloc] init];
    
    model.order_id = dic[@"order_id"];
    model.order_title = dic[@"order_title"];
    model.order_ptime = dic[@"order_ptime"];
    model.order_amount = dic[@"order_amount"];
    model.order_paystatus = dic[@"order_paystatus"];
    model.order_paytypeid = dic[@"order_paytypeid"];
    model.order_detail = dic[@"order_detail"];
    model.order_goodsid = dic[@"order_goodsid"];
    model.order_goodstypeid = dic[@"order_goodstypeid"];
    model.order_sn = dic[@"order_sn"];
    return model;
}

- (NSComparisonResult)compare:(OrderModel *)other
{
    if (self.order_ptime.integerValue > other.order_ptime.integerValue) {
        return NSOrderedDescending;
    } else if (self.order_ptime.integerValue < other.order_ptime.integerValue) {
        return NSOrderedAscending;
    } else {
        return NSOrderedSame;
    }
}

@end
