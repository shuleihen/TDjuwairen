//
//  AliveListVisitCardExtra.h
//  TDjuwairen
//
//  Created by zdy on 2017/9/4.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AliveListVisitCardExtra : NSObject
@property (nonatomic, copy) NSString *masterId;
@property (nonatomic, copy) NSString *masterNickName;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *desc;

- (id)initWithDictionary:(NSDictionary *)dict;
@end
