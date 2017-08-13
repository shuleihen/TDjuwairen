//
//  StockPoolSettingListModel.h
//  TDjuwairen
//
//  Created by deng shu on 2017/8/13.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StockPoolSettingListModel : NSObject
/// 持仓理由
@property (nonatomic, copy) NSString *record_desc;
/// 记录ID
@property (nonatomic, copy) NSString *record_id;
/// true表示已阅读
@property (nonatomic, assign) BOOL record_is_visited;
/// 持仓比
@property (nonatomic, copy) NSString *record_total_ratio;
/// true表示可以访问详情页
@property (nonatomic, assign) BOOL record_is_unlock;
/// true表示最新
@property (nonatomic, assign) BOOL record_is_new;
/// 时间戳
@property (nonatomic, copy) NSNumber *record_time;
/// 是否过期
@property (nonatomic, assign) BOOL recordExpired;
/// 是否是过期限cell
@property (nonatomic, assign) BOOL recordExpiredIndexCell;

- (NSString *)getWeekDayStr:(NSInteger)week;



- (instancetype)initWithDict:(NSDictionary *)dict;
@end
