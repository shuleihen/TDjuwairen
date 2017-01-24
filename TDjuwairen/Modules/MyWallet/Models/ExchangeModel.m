//
//  ExchangeModel.m
//  TDjuwairen
//
//  Created by 团大 on 2016/11/24.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "ExchangeModel.h"

@implementation ExchangeModel

+ (ExchangeModel *)getInstanceWithDic:(NSDictionary *)dic
{
    ExchangeModel *model = [[ExchangeModel alloc] init];
    model.prize_app_img = dic[@"prize_app_img"];
    model.prize_name = dic[@"prize_name"];
    model.prize_level = dic[@"prize_level"];
    model.prize_keynum = dic[@"prize_keynum"];
    model.is_exchange = [dic[@"is_exchange"] boolValue];
    
    return model;
}

@end
