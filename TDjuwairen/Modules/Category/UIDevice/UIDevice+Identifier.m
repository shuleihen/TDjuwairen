//
//  UIDevice+Identifier.m
//  baiwandian
//
//  Created by zdy on 15/10/9.
//  Copyright © 2015年 xinyunlian. All rights reserved.
//

#import "UIDevice+Identifier.h"
#import "NSString+Util.h"
#import "SAMKeychain.h"

static NSString *gKeyOfDeviceUDIDInSS  = @"gKeyOfDeviceUDIDInSS";
static NSString *gKeyOfDeviceUDIDServe = @"gKeyOfDeviceUDIDServe";

@implementation UIDevice (Identifier)

- (NSString *)uuid
{
    //return @"02:00:00:00:00:00";
    
    NSString *uuid = [SAMKeychain passwordForService:gKeyOfDeviceUDIDServe account:gKeyOfDeviceUDIDInSS];
    if (uuid == nil)
    {
        uuid = [NSUUID UUID].UUIDString;
        [SAMKeychain setPassword:uuid forService:gKeyOfDeviceUDIDServe account:gKeyOfDeviceUDIDInSS];
    }
    
    return uuid;
}

- (NSString *)uniqueDeviceIdentifier
{
    static NSString *uniqueIdentifier = nil;
    if (uniqueIdentifier == nil)
    {
        NSString *uuid = [[UIDevice currentDevice] uuid];
        NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
        
        NSString *stringToHash = [[NSString stringWithFormat:@"%@%@",uuid,bundleIdentifier] uppercaseString];
        uniqueIdentifier = [[stringToHash md5] uppercaseString];
        
        NSLog(@"设备唯一标识号: %@", uniqueIdentifier);
    }
    
    return uniqueIdentifier;
}
@end
