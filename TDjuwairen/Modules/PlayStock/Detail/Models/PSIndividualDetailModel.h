//
//  PSIndividualDetailModel.h
//  TDjuwairen
//
//  Created by zdy on 2017/7/14.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayStockDefine.h"

@interface PSIndividualDetailModel : NSObject
@property (nonatomic, strong) NSString *guessId;
@property (nonatomic, copy) NSString *stockName;
@property (nonatomic, copy) NSString *stockCode;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger season;
@property (nonatomic, assign) NSInteger guessKeyNum;
//后台悬赏的钥匙数，用户发起的竞猜则为0
@property (nonatomic, assign) NSInteger rewardKeyNum;
@property (nonatomic, assign) NSInteger joinNum;
@property (nonatomic, assign) BOOL isReward;
@property (nonatomic, assign) BOOL isClosed;
@property (nonatomic, assign) NSInteger result;
@property (nonatomic, assign) NSInteger rate;
@property (nonatomic, strong) NSNumber *endPrice;
@property (nonatomic, assign) long long endTime;
@property (nonatomic, strong) NSArray *joinList;
@property (nonatomic, assign) NSInteger extra_keyNum;

- (id)initWithDictionary:(NSDictionary *)dict;
- (NSString *)statusString;
- (NSString *)winStatusString;
@end
