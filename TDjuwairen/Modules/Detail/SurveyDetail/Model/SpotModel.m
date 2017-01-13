//
//  SpotModel.m
//  TDjuwairen
//
//  Created by zdy on 2017/1/13.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "SpotModel.h"

@implementation SpotModel
+ (SpotModel *)getInstanceWithDictionary:(NSDictionary *)dic {
    SpotModel *model = [[SpotModel alloc] init];
    
    return model;
}
@end
