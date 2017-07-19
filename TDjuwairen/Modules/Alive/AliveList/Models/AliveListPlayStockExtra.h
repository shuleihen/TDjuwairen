//
//  AliveListPlayStockExtra.h
//  TDjuwairen
//
//  Created by zdy on 2017/7/19.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AliveListPlayStockExtra : NSObject
@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSString *companyCode;
@property (nonatomic, copy) NSString *guessId;
@property (nonatomic, copy) NSString *guessTime;
@property (nonatomic, copy) NSString *guessSeason;

- (id)initWithDictionary:(NSDictionary *)dict;
@end
