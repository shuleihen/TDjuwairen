//
//  NSString+Json.m
//  TDjuwairen
//
//  Created by zdy on 2017/8/16.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "NSString+Json.h"

@implementation NSString (Json)
+ (NSString *)jsonStringWithObject:(id)object {
    NSError *error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    if (error) {
        return @"";
    }
    
    return jsonString;
}
@end
