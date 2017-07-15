//
//  PSIndividualUserModel.h
//  TDjuwairen
//
//  Created by ZYP-MAC on 17/3/31.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PSIndividualUserModel : NSObject
/// 收盘价格
@property (copy, nonatomic) NSString *guess_end_price;
/// 竞猜股票代码
@property (copy, nonatomic) NSString *guess_stock;
///  股票名
@property (copy, nonatomic) NSString *guess_stock_name;
///  竞猜状态，0表示正在进行，1表示封盘，2表示收盘
@property (copy, nonatomic) NSString *guess_status;
/// 参与人数
@property (copy, nonatomic) NSString *guess_item_count;
/// 竞猜的均价
@property (copy, nonatomic) NSString *guess_avg_points;
///  竞猜人员列表
@property (strong, nonatomic) NSArray *guess_users;

///  竞猜状态描述
@property (copy, nonatomic) NSString *guessStatusStr;


- (id)initWithDictionary:(NSDictionary *)dict;
@end
