//
//  AliveRoomMasterModel.h
//  TDjuwairen
//
//  Created by zdy on 2017/3/10.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AliveRoomMasterModel : NSObject
@property (nonatomic, copy) NSString *masterId;
@property (nonatomic, copy) NSString *masterNickName;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *attenNum;
@property (nonatomic, copy) NSString *fansNum;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, assign) BOOL isAtten;
@property (nonatomic, copy) NSString *guessRate;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *roomInfo;
@property (nonatomic, copy) NSString *roomCover;
@property (nonatomic, assign) BOOL isMaster;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, assign) BOOL canModifyRoomCover;

- (id)initWithDictionary:(NSDictionary *)dict;
@end
