//
//  StockInfoModel.m
//  TDjuwairen
//
//  Created by zdy on 2017/1/17.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "StockInfoModel.h"

@implementation StockInfoModel
- (id)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        _stockId = dict[@"compnay_code"];
        _stockName = dict[@"company_name"];
        _score = dict[@"company_score"];
        _cover = dict[@"cover"];
        _joinGradeNum = dict[@"reivew_user_count"];
        _allCompanyNum = dict[@"all_company_count"];
        _orderNum = dict[@"company_rate"];
        _isAdd = [dict[@"is_mystock"] boolValue];
        _isLocked = [dict[@"isLock"] boolValue];
        _keyNum = [dict[@"keyNum"] integerValue];
        
    }
    return self;
}
@end
