//
//  IndividualStockRecordModel.h
//  TDjuwairen
//
//  Created by zdy on 2017/4/11.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IndividualStockRecordModel : NSObject
@property (nonatomic, copy) NSString *guessId;
@property (nonatomic, copy) NSString *stockName;
@property (nonatomic, copy) NSString *stockCode;
@property (nonatomic, copy) NSString *addTime;
@property (nonatomic, copy) NSString *guessDate;
// 0表示没有结束，1表示完全猜中，2表示获胜，3表示失败，4表示平局，5表示无效
/// 个股竞猜：竞猜状态， 0表示未结算，1表示完全猜中，2表示获胜钥匙，3表示失败 4表示平局
@property (nonatomic, assign) int status;
@property (nonatomic, assign) int season;
@property (nonatomic, assign) int keyNumber;
@property (nonatomic, copy) NSString *endPrice;
//@property (nonatomic, copy) NSString *guessReword;
@property (nonatomic, copy) NSString *guessPoint;
@property (nonatomic, assign) NSInteger joinNum;
@property (nonatomic, assign) NSInteger winnerNum;
@property (nonatomic, assign) NSInteger winKeyNum;
@property (nonatomic, assign) NSInteger extraKeyNum;
@property (nonatomic, assign) BOOL isWin;

- (id)initWithDictionary:(NSDictionary *)dict;
@end
