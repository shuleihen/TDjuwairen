//
//  NSString+TimeInfo.m
//  TDjuwairen
//
//  Created by 团大 on 16/5/17.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "NSString+TimeInfo.h"

@implementation NSString (TimeInfo)

//+(NSString *)setLabelsTime:(NSInteger)time
//{
//    NSDateFormatter*formatter=[[NSDateFormatter alloc]init];
//    NSDateFormatter* tempday = [[NSDateFormatter alloc] init];
//    NSDateFormatter* tempYear = [[NSDateFormatter alloc] init];
//    
//    NSDateFormatter *commentTime=[[NSDateFormatter alloc] init];
//    [commentTime setDateFormat:@"YYYY-MM-dd HH:mm:ss ZZZ"];
//    NSDate *tempDate=[NSDate date];
//    NSString *curdate=[NSString stringWithFormat:@"%ld",(long)[tempDate timeIntervalSince1970]];
//    NSLog(@"%@",curdate);
//    NSInteger timeNow=[curdate integerValue];
//    
//    [tempday setDateFormat:@"dd"];
//    [tempYear setDateFormat:@"YYYY"];
//    
//    NSInteger minute=(timeNow-time)/60;
//    
//    if (0<=minute&&minute<=5) {
//        return [NSString stringWithFormat:@"刚刚"];
//    }
//    
//    else if (5<minute&&minute<=60) {
//        return [NSString stringWithFormat:@"%ld分钟前",(long)minute];
//    }
//    
//    else if ([[tempday stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeNow]] isEqualToString:[tempday stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]]]){
//        [formatter setDateFormat:@"HH:mm"];
//        NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
//        return [NSString stringWithFormat:@"今天 %@",[formatter stringFromDate:date]];
//    }
//    
//    else if ([[tempday stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeNow]] intValue]-[[tempday stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]]intValue ]==1) {
//        [formatter setDateFormat:@"HH:mm"];
//        NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
//        return [NSString stringWithFormat:@"昨天 %@",[formatter stringFromDate:date]];
//    }
//    
//    else if ([[tempday stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeNow]] intValue]-[[tempday stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]]intValue ]!=1 && [[tempYear stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeNow]] isEqualToString:[tempYear stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]]]) {
//        [formatter setDateFormat:@"MM-dd HH:mm"];
//        NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
//        return [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
//    }
//    
//    else{
//        [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
//        NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
//        return [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
//    }
//}

+ (NSString *)prettyDateWithReference:(NSString  *)referenceStr {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *reference = [formatter dateFromString:referenceStr];
    NSString *suffix = @"现在";
    float different = [reference timeIntervalSinceDate:[NSDate date]];
    if (different < 0) {
        different = -different;
        suffix = @"前";
    }
    
    // days = different / (24 * 60 * 60), take the floor value
    float dayDifferent = floor(different / 86400);
    
    int days   = (int)dayDifferent;
    int weeks  = (int)floor(dayDifferent / 7);
    int months = (int)floor(dayDifferent / 30);
    int years  = (int)floor(dayDifferent / 365);
    
    // It belongs to today
    if (dayDifferent <= 0) {
        // lower than 60 seconds
        if (different < 60) {
            return @"刚刚";
        }
        
        // lower than 120 seconds => one minute and lower than 60 seconds
        if (different < 120) {
            return [NSString stringWithFormat:@"1分钟%@", suffix];
        }
        
        // lower than 60 minutes
        if (different < 60 * 60) {
            return [NSString stringWithFormat:@"%d分钟%@", (int)floor(different / 60), suffix];
        }
        
        // lower than 60 * 2 minutes => one hour and lower than 60 minutes
        if (different < 7200) {
            return [NSString stringWithFormat:@"1小时%@", suffix];
        }
        
        // lower than one day
        if (different < 86400) {
            return [NSString stringWithFormat:@"%d小时%@", (int)floor(different / 3600), suffix];
        }
    }
    // lower than one week
    else if (days < 7) {
        return [NSString stringWithFormat:@"%d天%@", days, suffix];
    }
    // lager than one week but lower than a month
    else if (weeks < 4) {
        return [NSString stringWithFormat:@"%d周%@", weeks, suffix];
    }
    // lager than a month and lower than a year
    else if (months < 12) {
        return [NSString stringWithFormat:@"%d个月%@", months, suffix];
    }
    // lager than a year
    else {
        return [NSString stringWithFormat:@"%d年%@", years, suffix];
    }
    
    return self.description;
}

@end
