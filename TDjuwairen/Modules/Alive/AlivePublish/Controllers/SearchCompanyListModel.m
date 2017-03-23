//
//  SearchCompanyListModel.m
//  TDjuwairen
//
//  Created by ZYP-MAC on 17/3/23.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "SearchCompanyListModel.h"

@implementation SearchCompanyListModel
- (id)initWithDictionary:(NSDictionary *)dict {
    if (self =  [super init]) {
        self.company_code = dict[@"company_code"];
        self.company_name = dict[@"company_name"];
        self.company_short = dict[@"company_short"];
    }
    return self;
}
@end
