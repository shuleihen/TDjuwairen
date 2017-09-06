//
//  AliveListStockPoolExtra.h
//  TDjuwairen
//
//  Created by zdy on 2017/8/12.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AliveListStockPoolExtra : NSObject
@property (nonatomic, copy) NSString *stockPoolId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;

- (id)initWithDictionary:(NSDictionary *)dict;
@end
