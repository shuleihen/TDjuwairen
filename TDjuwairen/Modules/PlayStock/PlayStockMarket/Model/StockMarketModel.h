//
//  StockMarketModel.h
//  TDjuwairen
//
//  Created by zdy on 2016/12/19.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StockMarketModel : NSObject
@property (nonatomic, assign) float endtime;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, assign) BOOL isWorking;
@property (nonatomic, assign) float price;
@property (nonatomic, assign) BOOL isJoin;
@property (nonatomic, assign) int joinType;
@property (nonatomic, assign) float upPre;
@property (nonatomic, strong) NSArray *joinUserList;
- (id)initWithDictionary:(NSDictionary *)dict;
@end
