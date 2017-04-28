//
//  AliveListForwardModel.h
//  TDjuwairen
//
//  Created by zdy on 2017/3/30.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AliveTypeDefine.h"

@interface AliveListForwardModel : NSObject
@property (nonatomic, copy) NSString *aliveId;
@property (nonatomic, copy) NSString *aliveImg;
@property (nonatomic, assign) AliveType aliveType;
@property (nonatomic, copy) NSString *masterId;
@property (nonatomic, copy) NSString *masterNickName;
@property (nonatomic, copy) NSString *aliveTitle;
@property (nonatomic, strong) NSArray *aliveTags;
@property (nonatomic, copy) NSString *stockCode;
@property (nonatomic, copy) NSString *forwardUrl;

- (id)initWithDictionary:(NSDictionary *)dict;
@end
