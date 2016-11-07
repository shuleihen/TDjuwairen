//
//  StockListModel.m
//  TDjuwairen
//
//  Created by 团大 on 2016/11/4.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "StockListModel.h"

@implementation StockListModel

+ (StockListModel *)getInstanceWithDictionary:(NSDictionary *)dic
{
    StockListModel *model = [[StockListModel alloc] init];
    model.survey_cover = dic[@"survey_cover"];
    model.survey_url = dic[@"survey_url"];
    model.company_code = dic[@"company_code"];
    model.company_name = dic[@"company_name"];
    model.survey_id = dic[@"survey_id"];
    model.survey_title = dic[@"survey_title"];
    return model;
}

@end
