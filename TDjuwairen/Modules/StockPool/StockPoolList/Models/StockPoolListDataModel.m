//
//  StockPoolListDataModel.m
//  TDjuwairen
//
//  Created by ZYP-MAC on 2017/8/14.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "StockPoolListDataModel.h"

@implementation StockPoolListDataModel
- (instancetype)initWithDict:(NSDictionary *)dict {
    
    if (self = [super init]) {
        self.expire_index = dict[@"expire_index"];
        self.expire_time = dict[@"expire_time"];
        if (dict[@"list"]) {
            NSMutableArray *tempArrM = [NSMutableArray array];
            for (NSDictionary *listDict in dict[@"list"]) {
                StockPoolListCellModel *cellModel = [[StockPoolListCellModel alloc] initWithDict:listDict];
                [tempArrM addObject:cellModel];
            }
            self.list = [tempArrM mutableCopy];
            
        }
        
    }
    return self;
}
@end
