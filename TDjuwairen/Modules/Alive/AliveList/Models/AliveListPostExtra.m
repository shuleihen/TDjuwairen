//
//  AliveListPostExtra.m
//  TDjuwairen
//
//  Created by zdy on 2017/7/20.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveListPostExtra.h"

@implementation AliveListPostExtra
- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.aliveTags = dict[@"alive_com_tag"];
        self.aliveStockTags = dict[@"alive_com_stock"];
    }
    return self;
}

@end
