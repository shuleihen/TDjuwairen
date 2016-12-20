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
@property (nonatomic, copy) NSString *traAmount;
@property (nonatomic, copy) NSString *traNumber;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *time;

- (float)nowPriValue;
- (float)priValue;
- (float)priPercentValue;
@end

@protocol StockManagerDelegate <NSObject>

- (void)reloadWithStocks:(NSDictionary *)stocks;

@end

@interface StockManager : NSObject
@property (nonatomic, strong) NSMutableArray *stockIds;
@property (nonatomic, weak) id<StockManagerDelegate>delegate;

// 查询时间间隔，默认15秒
@property (nonatomic, assign) NSInteger interval;

- (void)addStocks:(NSArray *)stockArray;

// 开始查询 stockIds 里面的股票信息，默认每15秒查询一次
- (void)start;
- (void)stop;
@end
