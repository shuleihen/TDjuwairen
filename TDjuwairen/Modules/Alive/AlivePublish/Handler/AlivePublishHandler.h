//
//  AlivePublishHandler.h
//  TDjuwairen
//
//  Created by zdy on 2017/9/6.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlivePublishHandler : NSObject
+ (BOOL)isOpenStockHolder;
+ (NSString *)getStockHolderName;
+ (NSString *)getStockHolderCode;
@end