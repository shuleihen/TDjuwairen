//
//  MyGuessInfo.h
//  TDjuwairen
//
//  Created by zdy on 2016/12/27.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyGuessInfo : NSObject
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) double endTime;
@property (nonatomic, assign) float endPri;
@property (nonatomic, assign) BOOL isClosed;
@property (nonatomic, assign) NSInteger season;
@property (nonatomic, assign) float buyPri;
@property (nonatomic, assign) NSInteger buyKeyNum;
@property (nonatomic, copy) NSString *addTime;
@property (nonatomic, assign) BOOL isWin;
@property (nonatomic, assign) float odds;
@property (nonatomic, copy) NSString *stockName;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *statusString;
@property (nonatomic, copy) NSString *seasonString;
- (id)initWithDict:(NSDictionary *)dict;
@end
