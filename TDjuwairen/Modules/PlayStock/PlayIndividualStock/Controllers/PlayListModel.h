//
//  PlayListModel.h
//  TDjuwairen
//
//  Created by deng shu on 2017/3/28.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayListModel : NSObject

@property (nonatomic, copy) NSString *guess_company;
@property (nonatomic, strong) NSNumber *guess_end_price;
/// 0表示正在进行，1表示已封盘，2表示已收盘
@property (nonatomic, strong) NSNumber *guess_status;
@property (nonatomic, copy) NSNumber *guess_season;
@property (nonatomic, copy) NSString *guess_key_num;
@property (nonatomic, strong) NSNumber *guess_id;

@property (nonatomic, copy) NSString *com_code;
@property (nonatomic, copy) NSString *guess_item_num;
@property (nonatomic, copy) NSString *stock;
@property (nonatomic, strong) NSArray *winner_list;

@property (nonatomic, strong) NSDictionary *artile_info;
@property (nonatomic, assign) BOOL has_join;

- (id)initWithDictionary:(NSDictionary *)dict;
@end
