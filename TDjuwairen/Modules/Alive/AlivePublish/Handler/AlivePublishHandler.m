//
//  AlivePublishHandler.m
//  TDjuwairen
//
//  Created by zdy on 2017/9/6.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AlivePublishHandler.h"
#import "SettingHandler.h"
#import "NSDate+Util.h"

@implementation AlivePublishHandler
+ (BOOL)isOpenStockHolder {
    // 是否保存过
    NSInteger time = [SettingHandler getStockHolderOpenTime];
    if (time == 0) {
        return NO;
    }
    
    // 是否为当天
    if (![NSDate isCurrentDayWithTimeInterval:time]) {
        [SettingHandler saveStockHolderOpenTime:0];
        return NO;
    }
    
    return YES;
}

+ (NSString *)getStockHolderCode {
    NSString *string = [SettingHandler getStockHolderName];
    NSArray *array = [string componentsSeparatedByString:@" "];
    if (array.count == 2) {
        return array.firstObject;
    }
    
    return @"";
}
+ (NSString *)getStockHolderName {
    return [SettingHandler getStockHolderName];
}
@end
