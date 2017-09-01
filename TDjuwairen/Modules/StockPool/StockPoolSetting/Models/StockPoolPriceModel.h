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
@property (nonatomic, assign) BOOL isFree;
/// 钥匙数量
@property (nonatomic, copy) NSNumber *key_num;
/// 天数
@property (nonatomic, copy) NSNumber *day;
// 1表示周，2表示月
@property (nonatomic, copy) NSNumber *term;


- (instancetype)initWithDict:(NSDictionary *)dict;
@end
