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

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"
//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"

//短信验证码
#import <SMS_SDK/SMSSDK.h>

#import "GuideViewController.h"
#import "HexColors.h"

@interface AppDelegate ()
{
    BOOL isFirst;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    int cacheSizeMemory = 4*1024*1024; // 4MB
    int cacheSizeDisk = 32*1024*1024; // 32MB
    NSURLCache *shardCache = [[NSURLCache alloc]initWithMemoryCapacity:cacheSizeMemory diskCapacity:cacheSizeDisk diskPath:@"nsurlcache"];
    [NSURLCache setSharedURLCache:shardCache];
    
    [self setupUICommon];
    
//    FIXME: @fql 每一项配置 单独放到一个方法中
    /* 分享SDK */
    //短信验证码
    [SMSSDK registerApp:@"133251c67bb26" withSecret:@"f5535332a67b4228d0b792ef82c2ce34"];
    
    // Override point for customization after application launch.
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
//    FIXME: 这里出现了多次崩溃
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
    
    //设置第一次启动引导页
    NSFileManager *manager = [NSFileManager defaultManager];
    isFirst = YES;
    
    
    isFirst = ![manager fileExistsAtPath:[NSHomeDirectory() stringByAppendingString:@"/Documents/first.txt"]];
    if (isFirst) {
        //默认为白天模式
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        NSString *daynight = @"yes";
        [userdefault setValue:daynight forKey:@"daynight"];
        [userdefault synchronize];
        
        [manager createFileAtPath:[NSHomeDirectory() stringByAppendingString:@"/Documents/first.txt"] contents:nil attributes:nil];
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        GuideViewController *launchView=[mainStoryBoard instantiateViewControllerWithIdentifier:@"launchView"];
        self.window.rootViewController=launchView;
        [self.window makeKeyAndVisible];
    }
    
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
    [UINavigationBar appearance].barTintColor = [UIColor whiteColor];   // 设置导航条背景颜色
//    [UINavigationBar appearance].tintColor = [UIColor blueColor];     // 设置左右按钮，文字和图片颜色
    
    // 设置导航条标题字体和颜色
    NSDictionary *dict = @{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:18]};
    [[UINavigationBar appearance] setTitleTextAttributes:dict];
    
    // 设置导航条左右按钮字体和颜色
    NSDictionary *barItemDict = @{NSForegroundColorAttributeName:[HXColor hx_colorWithHexRGBAString:@"#1b69b1"], NSFontAttributeName:[UIFont systemFontOfSize:16]};
    [[UIBarButtonItem appearance] setTitleTextAttributes:barItemDict forState:UIControlStateNormal];
 
    [UITabBar appearance].tintColor = [HXColor hx_colorWithHexRGBAString:@"#1b69b1"];
}

@end
