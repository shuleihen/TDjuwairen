//
//  MyGuessModel.h
//  TDjuwairen
//
//  Created by zdy on 2016/12/27.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyGuessModel : NSObject
@property (nonatomic, copy) NSString *guessId;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) double endTime;
@property (nonatomic, assign) float endPri;
@property (nonatomic, assign) BOOL isClosed;
@property (nonatomic, assign) NSInteger season;
@property (nonatomic, assign) float buyPri;
@property (nonatomic, assign) NSInteger buyKeyNum;
@property (nonatomic, copy) NSString *addTime;
@property (nonatomic, assign) BOOL isWin;
@property (nonatomic, assign) int odds;
@property (nonatomic, copy) NSString *stockName;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *statusString;
@property (nonatomic, copy) NSString *seasonString;


#pragma mark - 个股竞猜新增参数
/// 1表示指数竞猜，2表示个股竞猜
@property (copy, nonatomic) NSString *guessCategory;
/// 股票代码
@property (copy, nonatomic) NSString *guessStock;
/// 竞猜日期
@property (copy, nonatomic) NSString *guessDate;


- (id)initWithDict:(NSDictionary *)dict;

- (id)initWithIndividualDict:(NSDictionary *)dict;

@end
