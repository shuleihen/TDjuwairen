//
//  AliveMasterModel.h
//  TDjuwairen
//
//  Created by zdy on 2017/3/9.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AliveMasterModel : NSObject
@property (nonatomic, copy) NSString *masterId;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *masterNickName;
@property (nonatomic, copy) NSString *attenNum;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, assign) BOOL isAtten;

- (id)initWithDictionary:(NSDictionary *)dict;
@end
