//
//  AliveListPostExtra.h
//  TDjuwairen
//
//  Created by zdy on 2017/7/20.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AliveListPostExtra : NSObject
// 推单标签(数组)
@property (nonatomic, strong) NSArray *aliveTags;
@property (nonatomic, strong) NSArray *aliveStockTags;

- (id)initWithDictionary:(NSDictionary *)dict;
@end
