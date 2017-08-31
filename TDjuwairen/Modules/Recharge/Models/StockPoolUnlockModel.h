//
//  StockPoolUnlockModel.h
//  TDjuwairen
//
//  Created by zdy on 2017/8/17.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StockPoolUnlockModel : NSObject
@property (nonatomic, strong) NSString *masterId;
@property (nonatomic, assign) BOOL isFree;
@property (nonatomic, copy) NSString *poolSetTip;
@property (nonatomic, assign) BOOL isSubscribeExpire;
@property (nonatomic, assign) BOOL isSubscribe;
@property (nonatomic, copy) NSString *poolSetDesc;
@property (nonatomic, copy) NSString *poolNextSetTip;
@property (nonatomic, assign) BOOL isHaveEnoughKey;

- (id)initWithDictionary:(NSDictionary *)dict;
@end
