//
//  NSDate+Util.m
//  TDjuwairen
//
//  Created by zdy on 2017/8/26.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "NSDate+Util.h"

@implementation NSDate (Util)
+ (BOOL)isCurrentDayWithTimeInterval:(NSInteger)timeInterval {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return [NSDate isCurrentDayWithDate:date];
}

+ (BOOL)isCurrentDayWithDate:(NSDate *)date {
    NSDate *now = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *nowCom = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    NSDateComponents *dateCom = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    
    return (nowCom.year == dateCom.year) && (nowCom.month == dateCom.month) && (nowCom.day == dateCom.day);
}
@end
