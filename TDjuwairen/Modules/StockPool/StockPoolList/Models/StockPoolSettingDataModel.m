//
//  StockPoolSettingDataModel.m
//  TDjuwairen
//
//  Created by deng shu on 2017/8/13.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "StockPoolSettingDataModel.h"

@implementation StockPoolSettingDataModel
- (instancetype)initWithDict:(NSDictionary *)dict {
    
    if (self = [super init]) {
        self.expire_index = dict[@"expire_index"];
        self.expire_time = dict[@"expire_time"];
        if (dict[@"list"]) {
            NSMutableArray *tempArrM = [NSMutableArray array];
            for (NSDictionary *listDict in dict[@"list"]) {
                StockPoolSettingListModel *listModel = [[StockPoolSettingListModel alloc] initWithDict:listDict];
                [tempArrM addObject:listModel];
            }
            self.list = [tempArrM mutableCopy];
            
        }
        
    }
    return self;
}
@end
