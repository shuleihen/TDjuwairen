//
//  LaunchHandler.m
//  TDjuwairen
//
//  Created by zdy on 2017/7/10.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "LaunchHandler.h"
#import "NetworkManager.h"
#import <AdSupport/AdSupport.h>
#import "CocoaLumberjack.h"

@implementation LaunchHandler
+ (void)checkInstallFormAd {
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        NSString *adfa = [ASIdentifierManager sharedManager].advertisingIdentifier.UUIDString;
        
        NetworkManager *ma = [[NetworkManager alloc] init];
        [ma POST:API_SaveDeviceInfo parameters:@{@"device": adfa?:@""} completion:^(id data, NSError *error){}];
    }
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
}
@end
