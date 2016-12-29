//
//  StockGuessModel.h
//  TDjuwairen
//
//  Created by zdy on 2016/12/27.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StockGuessModel : NSObject
@property (nonatomic, copy) NSString *guessId;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger season;
@property (nonatomic, assign) BOOL isClosed;
@property (nonatomic, assign) BOOL enable;
@property (nonatomic, copy) NSString *stockName;
@property (nonatomic, copy) NSString *stockId;
@property (nonatomic, assign) long long endTime;
@property (nonatomic, strong) NSArray *buyIndexs;

- (id)initWithDict:(NSDictionary *)dict;
@end
