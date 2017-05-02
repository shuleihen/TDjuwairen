//
//  SearchCompanyListModel.h
//  TDjuwairen
//
//  Created by ZYP-MAC on 17/3/23.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchCompanyListModel : NSObject<NSCopying>
/// 公司股票
@property (copy, nonatomic) NSString *company_code;
/// 公司名称
@property (copy, nonatomic) NSString *company_name;
/// 公司简称
@property (copy, nonatomic) NSString *company_short;

- (id)initWithDictionary:(NSDictionary *)dict;


+ (void)saveLocalHistoryModelArr:(NSArray *)arr;

+ (NSArray *)loadLocalHistoryModel;
+ (void)clearnLocalHistoryStock;


@end
