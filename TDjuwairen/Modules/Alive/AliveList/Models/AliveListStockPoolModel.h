//
//  AliveListStockPoolModel.h
//  TDjuwairen
//
//  Created by zdy on 2017/8/11.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AliveListStockPoolModel : NSObject
@property (nonatomic, copy) NSString *masterId;
@property (nonatomic, copy) NSString *userAvatar;
@property (nonatomic, copy) NSString *userNickName;
@property (nonatomic, copy) NSString *poolLogo;
@property (nonatomic, copy) NSString *poolSetTip;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, assign) NSInteger subscribeNum;
@property (nonatomic, assign) BOOL isExpire;
@property (nonatomic, assign) BOOL isSubscribe;
@property (nonatomic, assign) BOOL isMaster;
@property (nonatomic, copy) NSString *poolDesc;
@property (nonatomic, assign) BOOL isFree;
// 收藏中是否有新记录
@property (nonatomic, assign) BOOL hasNewRecord;
- (id)initWithDictionary:(NSDictionary *)dict;
@end
