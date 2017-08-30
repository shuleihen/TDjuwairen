//
//  StockPoolListDataModel.h
//  TDjuwairen
//
//  Created by ZYP-MAC on 2017/8/14.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StockPoolListCellModel.h"
@interface StockPoolListDataModel : NSObject
/// 过期时间戳
@property (nonatomic, copy) NSNumber *expire_time;
/// 过期线位置 表示过期线索引，当为1时，表示位于list中的索引为1之前 即在 索引0 和索引 1 之间
@property (nonatomic, copy) NSNumber *expire_index;
/// 过期数组
@property (nonatomic, strong) NSArray *expireArr;
/// 未过期数组
@property (nonatomic, strong) NSArray *currentArr;
@property (nonatomic, strong) NSArray *list;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
