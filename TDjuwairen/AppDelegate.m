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
#import "VideoDetailViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import "GuideViewController.h"
#import "HexColors.h"
#import "YXFont.h"
#import "CocoaLumberjack.h"
#import "NetworkManager.h"
#import "TDNavigationController.h"
#import "UMMobClick/MobClick.h"
#import "WXApi.h"
#import "WXApiManager.h"

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#import "NotificationDef.h"
#import "StockDetailViewController.h"

#import <CloudPushSDK/CloudPushSDK.h>
#import "LaunchHandler.h"
#import "LoginManager.h"
#import "SettingHandler.h"
#import "SystemAudioHandler.h"
#import "AliveDetailViewController.h"
#import "ViewpointDetailViewController.h"
#import "NSString+Util.h"
#import "AliveRoomViewController.h"
#import "SurveyDeepTableViewController.h"
#import "SettingHandler.h"
#import "SurveyDetailWebViewController.h"
#import "StockPoolHandler.h"


@interface AppDelegate ()<UNUserNotificationCenterDelegate>
@property (nonatomic, strong) UITabBarController *tabBarController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
#ifdef DEBUG
    NSLog(@"HomeDirectory = %@",NSHomeDirectory());
#endif
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self setupUICommon];
    [self setupURLCacheSize];
    [self setupShareSDK];
    [self setupWebImageCache];
    [self checkSwitchToGuide];
    [self setupLog];
    [self setupWithUMMobClick];
    [self setupAliCloudPushWithLaunchOptions:launchOptions];
    [StockPoolHandler setupStockPoolLocalNotifi];
    
    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    // 检测是否从广告链接下载的
    [self checkIsFistLaunch];
    
     // 测试本地通知
//    [self performSelector:@selector(testLocalNotifi) withObject:nil afterDelay:1.0];
    
    [LoginManager loginHandler];
    
    return YES;
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
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
    [center removeAllDeliveredNotifications];
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

// NOTE: 2.0 - 9.0使用
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    [self handleSchemaLinkWithUrl:url];
    return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler
{
    restorationHandler(nil);

    NSURL *url = userActivity.webpageURL;
    [self handleSchemaLinkWithUrl:url];
    
    return YES;
}

- (void)handleSchemaLinkWithUrl:(NSURL *)url {
    if (!url) {
        return;
    }
    
    DDLogInfo(@"Application open links url = %@",url.absoluteString);
    
    NSArray *paths = url.pathComponents;
    
    if (paths.count >= 3) {
        NSString *one = paths[1];
        if ([one isEqualToString:@"survey"]) {
            
            NSString *code = paths[2];
            if ([code isValidateStockCode]) {
                // 股票主页
                StockDetailViewController *vc = [[UIStoryboard storyboardWithName:@"SurveyDetail" bundle:nil] instantiateInitialViewController];
                vc.stockCode = code;
                vc.hidesBottomBarWhenPushed = YES;
                
                [self.tabBarController.selectedViewController pushViewController:vc animated:YES];
            } else if ([code isEqualToString:@"deeplist"]) {
                // 深度列表
                SurveyDeepTableViewController *vc = [[SurveyDeepTableViewController alloc] initWithStyle:UITableViewStylePlain];
                vc.hidesBottomBarWhenPushed = YES;
                [self.tabBarController.selectedViewController pushViewController:vc animated:YES];
            }
        } else if ([one isEqualToString:@"u"]) {
            // 用户主页
            NSString *user = paths[2];
            AliveRoomViewController *vc = [[AliveRoomViewController alloc] initWithMasterId:user];
            vc.hidesBottomBarWhenPushed = YES;
            
            [self.tabBarController.selectedViewController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - Push
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    DDLogInfo(@"Register deviceToken = %@", [deviceToken description]);
    
    [CloudPushSDK registerDevice:deviceToken withCallback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            DDLogInfo(@"Register deviceToken success.");
        } else {
            DDLogError(@"Register deviceToken failed, error: %@", res.error);
        }
    }];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
#ifdef  DEBUG
    DDLogError(@"Register Token Error = %@",error);
#endif
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}

// iOS10以下使用这个方法接收通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
#ifdef DEBUG
    DDLogInfo(@"iOS 10 以下 RemoteNotification UserInfo = %@",userInfo);
#endif
    [CloudPushSDK sendNotificationAck:userInfo];
    
    if ([SettingHandler isOpenRemoteBell]) {
        [SystemAudioHandler playRemoteBell];
    }
    
    if ([SettingHandler isRemoteShake]) {
        [SystemAudioHandler playRemoteShake];
    }
    
    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        // 应用处于前台的远程推送
        NSString *msg = userInfo[@"aps"][@"alert"];
        
        UIAlertAction *done = [UIAlertAction actionWithTitle:@"查看" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [self handlePushNotificationWithUserInfo:userInfo];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"忽略" style:UIAlertActionStyleCancel handler:nil];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:cancel];
        [alert addAction:done];
        
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
        
    } else {
        [self handlePushNotificationWithUserInfo:userInfo];
    }
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
#ifdef DEBUG
    DDLogInfo(@"iOS 10 以下 LocalNotification Notification = %@",notification);
#endif
    
    if ([notification.category isEqualToString:@"jwr.stockpool"]) {
        [SettingHandler clearAddStockPoolRecordCount];
    }
}


// iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
#ifdef DEBUG
    DDLogInfo(@"iOS10 以上 前台收到通知 UNNotification = %@",notification);
#endif
    
    if ([SettingHandler isOpenRemoteBell]) {
        [SystemAudioHandler playRemoteBell];
    }
    
    if ([SettingHandler isRemoteShake]) {
        [SystemAudioHandler playRemoteShake];
    }
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    // 通知打开回执上报
    [CloudPushSDK sendNotificationAck:userInfo];
    
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        // 应用处于前台时的远程推送接受
        NSString *msg = notification.request.content.body;
        
        UIAlertAction *done = [UIAlertAction actionWithTitle:@"查看" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [self handlePushNotificationWithUserInfo:userInfo];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"忽略" style:UIAlertActionStyleCancel handler:nil];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:cancel];
        [alert addAction:done];
        
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
        
        completionHandler(UNNotificationPresentationOptionSound);
    }else{
        // 应用处于前台时的本地推送接受
        completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
    }
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
#ifdef DEBUG
    NSLog(@"iOS10 以上 后台收到通知 UNNotificationResponse =  %@",response);
#endif
    
    if ([SettingHandler isOpenRemoteBell]) {
        [SystemAudioHandler playRemoteBell];
    }
    
    if ([SettingHandler isRemoteShake]) {
        [SystemAudioHandler playRemoteShake];
    }
    
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    // 通知打开回执上报
    [CloudPushSDK sendNotificationAck:userInfo];
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        // 应用处于后台时的远程推送接受
        [self handlePushNotificationWithUserInfo:userInfo];
    }else{
        // 应用处于后台时的本地推送接受
        if ([response.notification.request.trigger isKindOfClass:[UNCalendarNotificationTrigger class]]) {
            if ([response.actionIdentifier isEqualToString:@"jwr.stockpool"]) {
                [SettingHandler clearAddStockPoolRecordCount];
            }
        }
    }
}

- (void)handlePushNotificationWithUserInfo:(NSDictionary *)userInfo {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 1表示调研,2表示热点，3表示提问、4表示回答，8表示评分回复，10动态发布，15表示视频
        NSInteger type = [userInfo[@"type"] integerValue];
        
        
        if (type == 1) {
            // 调研
            NSString *stock_id = userInfo[@"code"];
            NSString *stock_name = userInfo[@"com_name"];
            NSString *content_id = userInfo[@"content_id"];
            BOOL isLock = [userInfo[@"is_lock"] boolValue];
            
            if (isLock) {
                StockDetailViewController *vc = [[UIStoryboard storyboardWithName:@"SurveyDetail" bundle:nil] instantiateInitialViewController];
                vc.stockCode = stock_id;
                vc.hidesBottomBarWhenPushed = YES;
                [self.tabBarController.selectedViewController pushViewController:vc animated:YES];
            } else {
                SurveyDetailWebViewController *vc = [[SurveyDetailWebViewController alloc] init];
                vc.contentId = content_id;
                vc.stockCode = stock_id;
                vc.stockName = stock_name;
                vc.surveyType = kSurveyTypeSpot;
                vc.url = [SurveyDetailContentViewController contenWebUrlWithContentId:content_id withTag:kSurveyTypeSpot];
                vc.hidesBottomBarWhenPushed = YES;
                [self.tabBarController.selectedViewController pushViewController:vc animated:YES];
            }
        } else if (type == 2) {
            // 热点
            NSString *stock_id = userInfo[@"code"];
            NSString *stock_name = userInfo[@"com_name"];
            NSString *content_id = userInfo[@"content_id"];
            // BOOL isLock = [userInfo[@"is_lock"] boolValue];
            
            SurveyDetailWebViewController *vc = [[SurveyDetailWebViewController alloc] init];
            vc.contentId = content_id;
            vc.stockCode = stock_id;
            vc.stockName = stock_name;
            vc.surveyType = kSurveyTypeSpot;
            vc.url = [SurveyDetailContentViewController contenWebUrlWithContentId:content_id withTag:kSurveyTypeHot];
            vc.hidesBottomBarWhenPushed = YES;
            [self.tabBarController.selectedViewController pushViewController:vc animated:YES];
        } else if (type == 15) {
            // 视频
            NSString *content_id = userInfo[@"content_id"];
            
            if (content_id.length) {
                VideoDetailViewController *vc = [[VideoDetailViewController alloc] initWithVideoId:content_id];
                vc.hidesBottomBarWhenPushed = YES;
                [self.tabBarController.selectedViewController pushViewController:vc animated:YES];
                return;
            }
        } else if (type == 10) {
            NSString *content_id = userInfo[@"content_id"];
            NSInteger aliveType = [userInfo[@"content_type"] integerValue];
            // 动态类型 1表示话题、2表示推单、5表示观点
            
            if (aliveType == kAliveViewpoint) {
                ViewpointDetailViewController *vc = [[ViewpointDetailViewController alloc] initWithAliveId:content_id aliveType:aliveType];
                vc.hidesBottomBarWhenPushed = YES;
                [self.tabBarController.selectedViewController pushViewController:vc animated:YES];
            } else {
                AliveDetailViewController *vc = [[AliveDetailViewController alloc] init];
                vc.aliveID = content_id;
                vc.aliveType = aliveType;
                vc.hidesBottomBarWhenPushed = YES;
                [self.tabBarController.selectedViewController pushViewController:vc animated:YES];
            }
        }
        
    });
}

#pragma mark - Setup
- (void)setupUICommon {
    
}

- (void)setupURLCacheSize
{
    int cacheSizeMemory = 4*1024*1024; // 4MB
    int cacheSizeDisk = 32*1024*1024; // 32MB
    NSURLCache *shardCache = [[NSURLCache alloc]initWithMemoryCapacity:cacheSizeMemory diskCapacity:cacheSizeDisk diskPath:@"nsurlcache"];
    [NSURLCache setSharedURLCache:shardCache];
}

- (void)setupShareSDK
{
    [ShareSDK registerApp:@"146618e9f6467"
     
          activePlatforms:@[@(SSDKPlatformSubTypeWechatSession),
                            @(SSDKPlatformSubTypeWechatTimeline),
                            @(SSDKPlatformTypeQQ),
                            @(SSDKPlatformTypeSinaWeibo)]
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
                 [appInfo SSDKSetupWeChatByAppId:@"wx08cb55058d7f237b"
                                       appSecret:@"ea759c2a15c3affb5d956cb8394c8402"];
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
        [userdefault synchronize];
    }
    else
    {
        self.tabBarController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
        self.window.rootViewController = self.tabBarController;
        [self.window makeKeyAndVisible];
    }
}

- (void)setupLog
{
    [DDLog addLogger:[DDTTYLogger sharedInstance]]; // TTY = Xcode console
    //    [DDLog addLogger:[DDASLLogger sharedInstance]]; // ASL = Apple System Logs
    
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

- (void)setupWithUMMobClick{
    UMConfigInstance.appKey = @"5844d3cf5312dd6419000c75";
    UMConfigInstance.channelId = @"App Store";
    //    UMConfigInstance.eSType = E_UM_GAME; //仅适用于游戏场景，应用统计不用设置
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
}

- (void)setupAliCloudPushWithLaunchOptions:(NSDictionary *)launchOptions {
    
    // SDK初始化
    [CloudPushSDK asyncInit:@"23699780" appSecret:@"336e293e6ab707765ef780d7a73764b2" callback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            DDLogInfo(@"Push SDK init success, deviceId: %@.", [CloudPushSDK getDeviceId]);
        } else {
            DDLogError(@"Push SDK init failed, error: %@", res.error);
        }
    }];
    
    
    //iOS10必须加下面这段代码。
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_9_x_Max) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        
        UNAuthorizationOptions types10=UNAuthorizationOptionBadge|UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
        [center requestAuthorizationWithOptions:types10 completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                //点击允许
                //这里可以添加一些自己的逻辑
            } else {
                //点击不允许
                //这里可以添加一些自己的逻辑
            }
        }];

    } else if ((NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_8_0) && (NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_9_x_Max)) {
        //如果你期望使用交互式(只有iOS 8.0及以上有)的通知，请参考下面注释部分的初始化代码
    
        UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    
    BOOL isClosePush = [[NSUserDefaults standardUserDefaults] boolForKey:@"isClosePush"];
    if (!isClosePush) {
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }

    // 点击通知将App从关闭状态启动时，将通知打开回执上报
    [CloudPushSDK sendNotificationAck:launchOptions];
}

- (void)checkIsFistLaunch {
    [LaunchHandler checkInstallFormAd];
}

- (void)loadAd {
    
}
@end
