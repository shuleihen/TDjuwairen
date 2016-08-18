//
//  AppDelegate.m
//  TDjuwairen
//
//  Created by 团大 on 16/5/11.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "AppDelegate.h"
#import "SDWebImageDownloader.h"
#import "SDWebImageManager.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import <SMS_SDK/SMSSDK.h>

#import "GuideViewController.h"
#import "HexColors.h"
#import "YXFont.h"
#import "UIdaynightModel.h"
#import "CocoaLumberjack.h"

@interface AppDelegate ()
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setupUICommon];
    [self setupURLCacheSize];
    [self setupSMSSDK];
    [self setupShareSDK];
    [self setupWebImageCache];
    [self checkSwitchToGuide];
    [self setupLog];
    
    return YES;
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [[NSURLCache sharedURLCache] setDiskCapacity:0];
    [[NSURLCache sharedURLCache] setMemoryCapacity:0];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)setupUICommon
{
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    UIdaynightModel *daynightmodel = [UIdaynightModel sharedInstance];
    NSString *daynight = [userdefault objectForKey:@"daynight"];
    if ([daynight isEqualToString:@"yes"]) {
        [daynightmodel day];
    }
    else
    {
        [daynightmodel night];
    }
    
    [UINavigationBar appearance].barTintColor = daynightmodel.navigationColor;   // 设置导航条背景颜色
    [UINavigationBar appearance].translucent = NO;
//    [UINavigationBar appearance].tintColor = [UIColor blueColor];     // 设置左右按钮，文字和图片颜色
    
    // 设置导航条标题字体和颜色
    NSDictionary *dict = @{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName:[YXFont mediumFontSize:17.0f]};
    [[UINavigationBar appearance] setTitleTextAttributes:dict];
    
    // 设置导航条左右按钮字体和颜色
    NSDictionary *barItemDict = @{NSForegroundColorAttributeName:[HXColor hx_colorWithHexRGBAString:@"#1b69b1"], NSFontAttributeName:[YXFont lightFontSize:16.0f]};
    [[UIBarButtonItem appearance] setTitleTextAttributes:barItemDict forState:UIControlStateNormal];
 
    [UITabBar appearance].barTintColor = daynightmodel.navigationColor;
    [UITabBar appearance].tintColor = [HXColor hx_colorWithHexRGBAString:@"#1b69b1"];
    [UITabBar appearance].translucent = NO;
}

- (void)setupURLCacheSize
{
    int cacheSizeMemory = 4*1024*1024; // 4MB
    int cacheSizeDisk = 32*1024*1024; // 32MB
    NSURLCache *shardCache = [[NSURLCache alloc]initWithMemoryCapacity:cacheSizeMemory diskCapacity:cacheSizeDisk diskPath:@"nsurlcache"];
    [NSURLCache setSharedURLCache:shardCache];
}

- (void)setupSMSSDK
{
    [SMSSDK registerApp:@"133251c67bb26" withSecret:@"f5535332a67b4228d0b792ef82c2ce34"];
}

- (void)setupShareSDK
{
    [ShareSDK registerApp:@"133251c67bb26"
     
          activePlatforms:@[@(SSDKPlatformSubTypeWechatSession),
                            @(SSDKPlatformSubTypeWechatTimeline),
                            @(SSDKPlatformTypeQQ)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"1536339071"
                                           appSecret:@"6e3dc36dd6dfcf49a595096e3bafb3d3"
                                         redirectUri:@"https://api.weibo.com/oauth2/default.html"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wx7296a52656167640"
                                       appSecret:@"d4ca652e5ed4107b4757fc2647802c37"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"101266993"
                                      appKey:@"3f65c3a58ad969e52387e085031349c4"
                                    authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];
}

- (void)setupWebImageCache
{
    SDWebImageDownloader *imgDownloader = SDWebImageManager.sharedManager.imageDownloader;
    imgDownloader.headersFilter  = ^NSDictionary *(NSURL *url, NSDictionary *headers) {
        
        NSFileManager *fm = [[NSFileManager alloc] init];
        NSString *imgKey = [SDWebImageManager.sharedManager cacheKeyForURL:url];
        NSString *imgPath = [SDWebImageManager.sharedManager.imageCache defaultCachePathForKey:imgKey];
        NSDictionary *fileAttr = [fm attributesOfItemAtPath:imgPath error:nil];
        
        NSMutableDictionary *mutableHeaders = [headers mutableCopy];
        
        if (fileAttr.count > 0) {
            NSDate *lastModifiedDate = (NSDate *)fileAttr[NSFileModificationDate];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
            formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
            formatter.dateFormat = @"EEE, dd MMM yyyy HH:mm:ss z";
            
            NSString *lastModifiedStr = [formatter stringFromDate:lastModifiedDate];
            lastModifiedStr = lastModifiedStr.length > 0 ? lastModifiedStr : @"";
            [mutableHeaders setValue:lastModifiedStr forKey:@"If-Modified-Since"];
            //            if (fileAttr.count > 0) {
            //                lastModifiedDate = (NSDate *)fileAttr[NSFileModificationDate];
            //            }
            
        }
        
        return mutableHeaders;
    };
}

- (void)checkSwitchToGuide
{
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSString *oldVersion = [userdefault stringForKey:@"version"];
    NSDictionary *dict = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = dict[@"CFBundleShortVersionString"];
    if (![oldVersion isEqualToString:currentVersion]) {
        GuideViewController *launchView=[[GuideViewController alloc] init];
        self.window.rootViewController=launchView;
        [self.window makeKeyAndVisible];
        
        [userdefault setObject:currentVersion forKey:@"version"];
        [userdefault setObject:@"yes" forKey:@"daynight"];
        [userdefault synchronize];
    }
}

- (void)setupLog
{
    [DDLog addLogger:[DDTTYLogger sharedInstance]]; // TTY = Xcode console
    [DDLog addLogger:[DDASLLogger sharedInstance]]; // ASL = Apple System Logs
    
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    fileLogger.rollingFrequency = 60*60*24;         // 24 hours
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    [DDLog addLogger:fileLogger];
    
//    DDLogVerbose(@"Verbose");
//    DDLogDebug(@"Debug");
//    DDLogInfo(@"Info");
//    DDLogWarn(@"Warn");
//    DDLogError(@"Error");
}
@end
