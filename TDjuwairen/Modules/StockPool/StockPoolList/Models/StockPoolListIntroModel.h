//
//  StockPoolListIntroModel.h
//  TDjuwairen
//
//  Created by zdy on 2017/8/23.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StockPoolListIntroModel : NSObject
@property (nonatomic, copy) NSString *firstRecordDay;
@property (nonatomic, copy) NSString *shareURL;
@property (nonatomic, copy) NSString *intro;
@property (nonatomic, assign) NSInteger commentNum;
@property (nonatomic, assign) NSInteger subscribeNum;
@property (nonatomic, assign) BOOL isMaster;
@property (nonatomic, assign) NSInteger expireTime;
@property (nonatomic, assign) BOOL isSubscribed;
@property (nonatomic, assign) BOOL isFree;
@property (nonatomic, assign) NSInteger expireDay;
@property (nonatomic, copy) NSString *masterNickName;
@property (nonatomic, copy) NSString *masterAvatar;

- (id)initWithDictionary:(NSDictionary *)dict;
@end
