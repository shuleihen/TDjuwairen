//
//  StockManager.h
//  TDjuwairen
//
//  Created by zdy on 2016/11/22.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StockInfo : NSObject
@property (nonatomic, copy) NSString *gid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *yestodEndPri;
@property (nonatomic, copy) NSString *todayStartPri;
@property (nonatomic, copy) NSString *nowPri;            //当前价格
@property (nonatomic, copy) NSString *todayMax;
@property (nonatomic, copy) NSString *todayMin;
@property (nonatomic, assign) float traAmount;        // 成交股票金额(元)
@property (nonatomic, assign) float traNumber;        // 成交股票数量(一股)
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *allValue;         // 总市值
@property (nonatomic, copy) NSString *currentValue;     // 流通市值
@property (nonatomic, copy) NSString *dynamicRatio;     // 市盈率(动)

- (float)yestodEndPriValue;
- (float)nowPriValue;
- (float)priValue;
- (float)priPercentValue;
- (BOOL)enabled;
@end

@protocol StockManagerDelegate <NSObject>

- (void)reloadWithStocks:(NSDictionary *)stocks;

@end

@interface StockManager : NSObject
@property (nonatomic, strong) NSMutableArray *stockIds;
@property (nonatomic, weak) id<StockManagerDelegate>delegate;

// 是否开启定时器，默认开启
@property (nonatomic, assign) BOOL isOpenTimer;

// 查询时间间隔，默认15秒
@property (nonatomic, assign) NSInteger interval;

// 添加查询
- (void)addStocks:(NSArray *)stockArray;

// 单独查询一次
- (void)queryStockId:(NSString *)stockId;

// 默认每15秒查询一次
- (void)start;
- (void)stop;
- (void)stopThread;
@end
