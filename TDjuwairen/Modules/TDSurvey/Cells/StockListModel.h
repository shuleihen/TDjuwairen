//
//  StockListModel.h
//  TDjuwairen
//
//  Created by 团大 on 2016/11/4.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StockListModel : NSObject

@property (nonatomic,strong) NSString *survey_cover;

@property (nonatomic,strong) NSString *survey_url;

@property (nonatomic,strong) NSString *company_code;

@property (nonatomic,strong) NSString *company_name;

@property (nonatomic,strong) NSString *survey_id;

@property (nonatomic,strong) NSString *survey_title;

+(StockListModel *)getInstanceWithDictionary:(NSDictionary *)dic;

@end
