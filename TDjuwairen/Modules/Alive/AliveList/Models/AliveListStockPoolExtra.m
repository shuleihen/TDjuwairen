//
//  AliveListStockPoolExtra.m
//  TDjuwairen
//
//  Created by zdy on 2017/8/12.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveListStockPoolExtra.h"

@implementation AliveListStockPoolExtra
- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.title = dict[@"title"];
        self.desc = dict[@"desc"];
    }
    
    return self;
}
@end
