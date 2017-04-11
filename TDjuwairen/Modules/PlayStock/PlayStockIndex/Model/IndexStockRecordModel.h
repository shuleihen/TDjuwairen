//
//  IndexStockRecordModel.h
//  TDjuwairen
//
//  Created by zdy on 2016/12/27.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IndexStockRecordModel : NSObject
@property (nonatomic, copy) NSString *guessId;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) double endTime;
@property (nonatomic, assign) float endPri;
@property (nonatomic, assign) BOOL isClosed;
@property (nonatomic, copy) NSString *guessDate;
@property (nonatomic, assign) NSInteger season;
@property (nonatomic, assign) float buyPri;
@property (nonatomic, assign) NSInteger buyKeyNum;
@property (nonatomic, copy) NSString *addTime;
@property (nonatomic, assign) BOOL isWin;
@property (nonatomic, assign) int odds;
@property (nonatomic, copy) NSString *stockName;
/// 指数竞猜 竞猜状态， 0表示未结算，1表示完全猜中，2表示获胜钥匙，3表示失败 4表示平局
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *statusString;
@property (nonatomic, copy) NSString *seasonString;


- (id)initWithDict:(NSDictionary *)dict;
@end
