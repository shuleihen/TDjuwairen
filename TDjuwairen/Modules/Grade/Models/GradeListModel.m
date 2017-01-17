//
//  GradeListModel.m
//  TDjuwairen
//
//  Created by zdy on 2017/1/12.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "GradeListModel.h"

@implementation GradeListModel
- (id)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        _sortNumber = [dict[@"rank_num"] integerValue];
        _type = [dict[@"is_up"] integerValue];
        _grade = [dict[@"weight_score"] integerValue];
        _stockName = dict[@"company_name"];
        _stockId = dict[@"company_code"];
    }
    return self;
}
@end
