//
//  PSIndividualDetailModel.h
//  TDjuwairen
//
//  Created by zdy on 2017/7/12.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PSIndividualDetailModel : NSObject
@property (nonatomic, copy) NSString *guessId;
@property (nonatomic, copy) NSString *stockName;
@property (nonatomic, copy) NSString *stockCode;
@property (nonatomic, assign) long long endTime;
@property (nonatomic, assign) NSInteger season;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger allKeyNum;
@property (nonatomic, assign) NSInteger joinNum;
@property (nonatomic, assign) BOOL isJoin;
@property (nonatomic, strong) NSDictionary *artileInfo;

- (id)initWithDictionary:(NSDictionary *)dict;
@end
