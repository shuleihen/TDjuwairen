//
//  NSString+GetDevice.m
//  TDjuwairen
//
//  Created by 团大 on 2016/11/7.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "NSString+GetDevice.h"
#import <sys/utsname.h>

@implementation NSString (GetDevice)

+ (NSString *)getiPHoneDeviceType
{
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"1";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"1";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"1";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"1";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"1";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"1";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"1";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"1";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"1";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"1";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"1";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"1";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    
    return deviceString;
}

@end
