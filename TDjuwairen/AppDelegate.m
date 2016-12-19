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
#import "DetailPageViewController.h"
#import "SurDetailViewController.h"

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
#import "NetworkManager.h"
#import "UIStoryboard+MainStoryboard.h"
#import "TDNavigationController.h"

#import "UMMobClick/MobClick.h"

#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "WXApiManager.h"

#import "BPush.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

static BOOL isBackGroundActivateApplication;
@interface AppDelegate ()
{
    UITabBarController *_tabBarCtr;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
#ifdef DEBUG
    NSLog(@"HomeDirectory = %@",NSHomeDirectory());
#endif
    
    [NSThread sleepForTimeInterval:3.0];//设置启动页面时间
    
    [self setupUICommon];
    [self setupURLCacheSize];
    [self setupSMSSDK];
    [self setupShareSDK];
    [self setupWebImageCache];
    [self checkSwitchToGuide];
    [self setupLog];
    
    [self setupWithUMMobClick];
    
    [self setupWithBPush:application andDic:launchOptions];
    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    //    [center removeAllPendingNotificationRequests];
    
     // 测试本地通知
//    [self performSelector:@selector(testLocalNotifi) withObject:nil afterDelay:1.0];
    
    
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
    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter] ;
    [center removeAllDeliveredNotifications];       //清空已展示的通知
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

- (void)setupUICommon
{
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    UIdaynightModel *daynightmodel = [UIdaynightModel sharedInstance];
    NSString *daynight = [userdefault objectForKey:@"daynight"];
    if ([daynight isEqualToString:@"yes"]) {
        [daynightmodel day];
        [UINavigationBar appearance].barTintColor = daynightmodel.navigationColor;   // 设置导航条背景颜色
        [UINavigationBar appearance].translucent = NO;
        [UINavigationBar appearance].tintColor = [HXColor hx_colorWithHexRGBAString:@"#646464"];    // 设置左右按钮，文字和图片颜色
        
        // 设置导航条标题字体和颜色
        NSDictionary *dict = @{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName:[YXFont mediumFontSize:17.0f]};
        [[UINavigationBar appearance] setTitleTextAttributes:dict];
        
        // 设置导航条左右按钮字体和颜色
        NSDictionary *barItemDict = @{NSForegroundColorAttributeName:[HXColor hx_colorWithHexRGBAString:@"#1b69b1"], NSFontAttributeName:[YXFont lightFontSize:16.0f]};
        [[UIBarButtonItem appearance] setTitleTextAttributes:barItemDict forState:UIControlStateNormal];
    }
    else
    {
        [daynightmodel night];
        [UINavigationBar appearance].barTintColor = daynightmodel.navigationColor;   // 设置导航条背景颜色
        [UINavigationBar appearance].translucent = NO;
        [UINavigationBar appearance].tintColor = daynightmodel.navigationColor;    // 设置左右按钮，文字和图片颜色
        // 设置导航条标题字体和颜色
        NSDictionary *dict = @{NSForegroundColorAttributeName:daynightmodel.titleColor, NSFontAttributeName:[YXFont mediumFontSize:17.0f]};
        [[UINavigationBar appearance] setTitleTextAttributes:dict];
        
        // 设置导航条左右按钮字体和颜色
        NSDictionary *barItemDict = @{NSForegroundColorAttributeName:[HXColor hx_colorWithHexRGBAString:@"#1b69b1"], NSFontAttributeName:[YXFont lightFontSize:16.0f]};
        [[UIBarButtonItem appearance] setTitleTextAttributes:barItemDict forState:UIControlStateNormal];
    }
    
    
    
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
    else
    {
        _tabBarCtr = [[UIStoryboard mainStoryboard] instantiateViewControllerWithIdentifier:@"tabbarView"];
        self.window.rootViewController = _tabBarCtr;
        [self.window makeKeyAndVisible];
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

#pragma mark - 友盟统计
- (void)setupWithUMMobClick{
    UMConfigInstance.appKey = @"5844d3cf5312dd6419000c75";
    UMConfigInstance.channelId = @"App Store";
    //    UMConfigInstance.eSType = E_UM_GAME; //仅适用于游戏场景，应用统计不用设置
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
}

- (void)setupWithBPush:(UIApplication *)application andDic:(NSDictionary *)launchOptions{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        [[NSUserDefaults standardUserDefaults] setObject:launchOptions forKey:@"launchOptions"];
        
        NSLog(@"first launch");
        // iOS10 下需要使用新的 API
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
            UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
            
            [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge)
                                  completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                      // Enable or disable features based on authorization.
                                      if (granted) {
                                          [application registerForRemoteNotifications];
                                      }
                                  }];
#endif
        }
        else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
            
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        }else {
            //        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
            //        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
        }
        
        //#warning 上线 AppStore 时需要修改BPushMode为BPushModeProduction 需要修改Apikey为自己的Apikey
        
        // 在 App 启动时注册百度云推送服务，需要提供 Apikey
        [BPush registerChannel:launchOptions apiKey:@"YewcrZIsfLIvO2MNoOXIO8ru" pushMode:BPushModeProduction withFirstAction:@"打开" withSecondAction:@"回复" withCategory:@"test" useBehaviorTextInput:YES isDebug:YES];
        
    }else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
        NSLog(@"second launch");
        UIApplication *app = [UIApplication sharedApplication];
        if ([app isRegisteredForRemoteNotifications]  == YES) {
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
                UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
                
                [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge)
                                      completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                          // Enable or disable features based on authorization.
                                          if (granted) {
                                              [application registerForRemoteNotifications];
                                          }
                                      }];
#endif
            }
            else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
                UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
                
                UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
                [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
            }else {
                //        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
                //        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
            }
            
            //#warning 上线 AppStore 时需要修改BPushMode为BPushModeProduction 需要修改Apikey为自己的Apikey
            
            // 在 App 启动时注册百度云推送服务，需要提供 Apikey
            [BPush registerChannel:launchOptions apiKey:@"YewcrZIsfLIvO2MNoOXIO8ru" pushMode:BPushModeProduction withFirstAction:@"打开" withSecondAction:@"回复" withCategory:@"test" useBehaviorTextInput:YES isDebug:YES];
        }
    }
    // App 是用户点击推送消息启动
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        NSLog(@"从消息启动:%@",userInfo);
        [BPush handleNotification:userInfo];
    }
}

- (void)testLocalNotifi
{
    NSLog(@"测试本地通知啦！！！");
    NSDate *fireDate = [[NSDate new] dateByAddingTimeInterval:5];
    [BPush localNotification:fireDate alertBody:@"这是本地通知" badge:3 withFirstAction:@"打开" withSecondAction:@"关闭" userInfo:nil soundName:nil region:nil regionTriggersOnce:YES category:nil useBehaviorTextInput:YES];
}

// 此方法是 用户点击了通知，应用在前台 或者开启后台并且应用在后台 时调起
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    // 打印到日志 textView 中
    NSLog(@"********** iOS7.0之后 background **********");
    //杀死状态下，直接跳转到跳转页面。
    if (application.applicationState == UIApplicationStateInactive && !isBackGroundActivateApplication)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSString *nothing = userInfo[@"view_id"];
            if (nothing == nil) {
                NSString *c = userInfo[@"code"];
                if (c == nil) {
                    //
                }
                else
                {
                    SurDetailViewController *dv = [[SurDetailViewController alloc] init];
                    
                    NSString *code = [c substringWithRange:NSMakeRange(0, 1)];
                    
                    NSString *companyCode ;
                    if ([code isEqualToString:@"6"]) {
                        companyCode = [NSString stringWithFormat:@"sh%@",c];
                    }
                    else
                    {
                        companyCode = [NSString stringWithFormat:@"sz%@",c];
                    }
                    dv.company_code = companyCode;
                    dv.module = 5;
                    [dv setHidesBottomBarWhenPushed:YES];
                    _tabBarCtr.selectedIndex = 0;
                    [_tabBarCtr.selectedViewController pushViewController:dv animated:YES];
                }
            }
            else
            {
                DetailPageViewController *detail = [[DetailPageViewController alloc]init];
                detail.view_id = userInfo[@"view_id"];
                detail.pageMode = @"view";
                [detail setHidesBottomBarWhenPushed:YES];
                _tabBarCtr.selectedIndex = 1;
                [_tabBarCtr.selectedViewController pushViewController:detail animated:YES];
            }
            NSLog(@"applacation is unactive ===== %@",userInfo);
        });
    }
    // 应用在后台。当后台设置aps字段里的 content-available 值为 1 并开启远程通知激活应用的选项
    if (application.applicationState == UIApplicationStateBackground) {
        NSLog(@"background is Activated Application ");
        // 此处可以选择激活应用提前下载邮件图片等内容。
        isBackGroundActivateApplication = YES;
        UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"收到一条消息" message:userInfo[@"aps"][@"alert"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
    NSLog(@"backgroud : %@",userInfo);
    
}

// 在 iOS8 系统中，还需要添加这个方法。通过新的 API 注册推送服务
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    
    [application registerForRemoteNotifications];
    
    
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"test:%@",deviceToken);
    [BPush registerDeviceToken:deviceToken];
    [BPush bindChannelWithCompleteHandler:^(id result, NSError *error) {
        //        [self.viewController addLogString:[NSString stringWithFormat:@"Method: %@\n%@",BPushRequestMethodBind,result]];
        // 需要在绑定成功后进行 settag listtag deletetag unbind 操作否则会失败
        // 网络错误
        if (error) {
            return ;
        }
        if (result) {
            // 确认绑定成功
            if ([result[@"error_code"]intValue]!=0) {
                return;
            }
            [BPush setTag:@"Mytag" withCompleteHandler:^(id result, NSError *error) {
                if (result) {
                    NSLog(@"设置tag成功");
                    NetworkManager *manager = [[NetworkManager alloc]initWithBaseUrl:API_HOST];
                    NSString *url = @"index.php/Index/resetUnreadMsg";
                    NSString *channel_id = [BPush getChannelId];
                    NSDictionary *para = @{@"channel_id":channel_id,
                                           @"type":@"1"};
                    [manager POST:url parameters:para completion:^(id data, NSError *error) {
                        //角标同步到后台
                        NSLog(@"%@",data);
                    }];
                }
            }];
        }
    }];
    // 打印到日志 textView 中
    //    [self.viewController addLogString:[NSString stringWithFormat:@"Register use deviceToken : %@",deviceToken]];
    
    
}

// 当 DeviceToken 获取失败时，系统会回调此方法
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"DeviceToken 获取失败，原因：%@",error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // App 收到推送的通知
    [BPush handleNotification:userInfo];
    NSLog(@"********** ios7.0之前 **********");
    // 应用在前台 或者后台开启状态下，不跳转页面，让用户选择。
    if (application.applicationState == UIApplicationStateActive || application.applicationState == UIApplicationStateBackground) {
        NSLog(@"acitve or background");
        UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"收到一条消息" message:userInfo[@"aps"][@"alert"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    else//杀死状态下，直接跳转到跳转页面。
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSString *nothing = userInfo[@"view_id"];
            if (nothing == nil) {
                NSString *c = userInfo[@"code"];
                if (c == nil) {
                    //
                }
                else
                {
                    SurDetailViewController *dv = [[SurDetailViewController alloc] init];
                    
                    NSString *code = [c substringWithRange:NSMakeRange(0, 1)];
                    
                    NSString *companyCode ;
                    if ([code isEqualToString:@"6"]) {
                        companyCode = [NSString stringWithFormat:@"sh%@",c];
                    }
                    else
                    {
                        companyCode = [NSString stringWithFormat:@"sz%@",c];
                    }
                    dv.company_code = companyCode;
                    dv.module = 5;
                    [dv setHidesBottomBarWhenPushed:YES];
                    _tabBarCtr.selectedIndex = 0;
                    [_tabBarCtr.selectedViewController pushViewController:dv animated:YES];
                }
            }
            else
            {
                DetailPageViewController *detail = [[DetailPageViewController alloc]init];
                detail.view_id = userInfo[@"view_id"];
                detail.pageMode = @"view";
                [detail setHidesBottomBarWhenPushed:YES];
                _tabBarCtr.selectedIndex = 1;
                [_tabBarCtr.selectedViewController pushViewController:detail animated:YES];
            }
            NSLog(@"applacation is unactive ===== %@",userInfo);
        });
    }
    
    NSLog(@"%@",userInfo);
    
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"接收本地通知啦！！！");
    [BPush showLocalNotificationAtFront:notification identifierKey:nil];
}

#pragma mark - 支付返回结果
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            NSString *resultStatus = resultDic[@"resultStatus"];
            if ([resultStatus isEqualToString:@"9000"]) {
                //通知支付成功
                [[NSNotificationCenter defaultCenter] postNotificationName:@"paySuccess" object:nil];
            }
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
        
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"%@",resultDic);
            //通知刷新钥匙
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshKeys" object:nil];
        }];
        return YES;
    }
    else
    {
        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
    
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            NSString *resultStatus = resultDic[@"resultStatus"];
            if ([resultStatus isEqualToString:@"9000"]) {
                //通知支付成功
                [[NSNotificationCenter defaultCenter] postNotificationName:@"paySuccess" object:nil];
            }
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
        
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"%@",resultDic);
            //通知刷新钥匙
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshKeys" object:nil];
            
            
        }];
        return YES;
    }
    else
    {
        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
    
}

#pragma mark - 微信支付回调

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

@end
