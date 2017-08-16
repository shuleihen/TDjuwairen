//
//  SPEditRecordModel.m
//  TDjuwairen
//
//  Created by zdy on 2017/8/15.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "SPEditRecordModel.h"

@implementation SPEditRecordModel

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.stockName = dict[@"item_stock_name"];
        self.stockCode = dict[@"item_stock"];
        self.ratio = dict[@"item_ratio"];
        self.type = [dict[@"item_operator"] integerValue];
        self.cellType = kSPEidtCellNormal;
    }
    return self;
}
@end
