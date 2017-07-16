//
//  PSIndividualListModel.h
//  TDjuwairen
//
//  Created by deng shu on 2017/3/28.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayStockDefine.h"

@interface PSIndividualListModel : NSObject
@property (nonatomic, strong) NSString *guessId;
@property (nonatomic, copy) NSString *stockName;
@property (nonatomic, copy) NSString *stockCode;
@property (nonatomic, copy) NSString *stockId;
@property (nonatomic, strong) NSNumber *guess_end_price;
// 0表示正在进行，1表示已封盘，2表示已收盘
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSNumber *guess_season;
@property (nonatomic, copy) NSString *guess_key_num;
@property (nonatomic, assign) NSInteger guess_item_num;
@property (nonatomic, strong) NSArray *winner_list;
@property (nonatomic, strong) NSArray *artile_list;
@property (nonatomic, assign) BOOL has_join;
@property (nonatomic, assign) BOOL isReward;

- (id)initWithDictionary:(NSDictionary *)dict;
- (NSArray *)artileTimeArray;
@end
