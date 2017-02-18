//
//  AppContext.m
//  RmbWithdraw
//
//  Created by zdy on 16/8/19.
//  Copyright © 2016年 lianlian. All rights reserved.
//

#import "AppContext.h"
#import "UIDevice+Identifier.h"
#import "AFNetworkReachabilityManager.h"
#import "CocoaLumberjack.h"

@implementation AppContext
@synthesize resolution = _resolution;
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static AppContext *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AppContext alloc] init];
    });
    return sharedInstance;
}

- (id)init
{
    if (self = [super init]) {
        CGRect rect = [[UIScreen mainScreen] bounds];
        _resolution = [NSString stringWithFormat:@"%.0f*%.0f", CGRectGetWidth(rect), CGRectGetHeight(rect)];
        _networkStatus = AFNetworkReachabilityStatusUnknown;
        
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status){
            _networkStatus = status;
            
            DDLogInfo(@"AFNetworkReachabilityManager network changed to: %@",[self networkType]);
        }];
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    }
    
    return self;
}

- (void)dealloc
{
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

- (NSString *)resolution {
    return _resolution;
}

- (NSString *)networkType {
    NSString *net_type;
    switch (self.networkStatus) {
        case AFNetworkReachabilityStatusUnknown:
            net_type = @"UNKNOWN";
            break;
        case AFNetworkReachabilityStatusNotReachable:
            net_type = @"NOTREACHABLE";
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
            net_type = @"WWAN";
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            net_type = @"WIFI";
            break;
        default:
            break;
    }
    
    return net_type;
}

- (NSString *)machineInfo {
    UIDevice *device = [UIDevice currentDevice];
    NSString *uuid = [device uniqueDeviceIdentifier];
    
    NSDictionary *dict = @{@"machineid":   uuid,
                           @"screen":       self.resolution,
                           @"manufacturer": @"Apple",
                           @"model":        device.model,
                           @"sdk":          device.systemVersion,
                           @"net_type":     [self networkType],
                         };
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:NULL];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (NSString *)version {
    NSString * versionNumber = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return versionNumber;
}

- (void)addHttpHeaderWithRequest:(NSMutableURLRequest *)request {
    [request addValue:[self machineInfo] forHTTPHeaderField:@"machineInfo"];
    [request addValue:[self version] forHTTPHeaderField:@"version"];
    
    // 身份窜
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"unique_str"];
    [request setValue:accessToken?accessToken:@"" forHTTPHeaderField:@"unique_str"];
    
    // SENDVERIFYCODE=35915b08bfd96b72c0763cfd7880c0e2cee9c907
    [request addValue:@"35915b08bfd96b72c0763cfd7880c0e2cee9c907" forHTTPHeaderField:@"SENDVERIFYCODE"];
}
@end
