//
//  StockPoolPriceModel.h
//  TDjuwairen
//
//  Created by deng shu on 2017/8/12.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StockPoolPriceModel : NSObject
/// 是否免费
@property (nonatomic, copy) NSString *is_free;
/// 钥匙数量
@property (nonatomic, copy) NSNumber *key_num;
/// 天数
@property (nonatomic, copy) NSNumber *day;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
