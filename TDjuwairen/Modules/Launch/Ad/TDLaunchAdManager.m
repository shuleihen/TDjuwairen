//
//  TDLaunchAdManager.m
//  TDjuwairen
//
//  Created by zdy on 2017/7/20.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "TDLaunchAdManager.h"
#import "XHLaunchAd.h"
#import "NetworkManager.h"
#import "TDAdvertModel.h"
#import "TDRechargeViewController.h"
#import "TDADHandler.h"

@interface TDLaunchAdManager()<XHLaunchAdDelegate>
@property (nonatomic, strong) TDAdvertModel *adModel;
@end

@implementation TDLaunchAdManager
+ (void)load
{
    [self shareManager];
}

+ (TDLaunchAdManager *)shareManager{
    static TDLaunchAdManager *instance = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken,^{
        instance = [[TDLaunchAdManager alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        //在UIApplicationDidFinishLaunching时初始化开屏广告
        //当然你也可以直接在AppDelegate didFinishLaunchingWithOptions中初始化
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            
            //初始化开屏广告
            [self setupXHLaunchAd];
            
        }];
    }
    return self;
}

-(void)setupXHLaunchAd {
    [XHLaunchAd setWaitDataDuration:3];
    
    NetworkManager *ma = [[NetworkManager alloc] init];
    [ma GET:API_IndexStartupPage parameters:nil completion:^(id data,NSError *error){
        
        if (!error) {
            NSArray *array = data;
            NSDictionary *dict = array.firstObject;
            
            TDAdvertModel *model = [[TDAdvertModel alloc] initWithDictionary:dict];
            self.adModel = model;
            
            //配置广告数据
            XHLaunchImageAdConfiguration *imageAdconfiguration = [XHLaunchImageAdConfiguration new];
            //广告停留时间
            imageAdconfiguration.duration = 3;
            //广告frame
            imageAdconfiguration.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            //广告图片URLString/或本地图片名(.jpg/.gif请带上后缀)
            imageAdconfiguration.imageNameOrURLString = model.adImageUrl;
            //缓存机制(仅对网络图片有效)
            //为告展示效果更好,可设置为XHLaunchAdImageCacheInBackground,先缓存,下次显示
            imageAdconfiguration.imageOption = XHLaunchAdImageDefault;
            //图片填充模式
            imageAdconfiguration.contentMode = UIViewContentModeScaleToFill;
            //广告点击打开链接
            imageAdconfiguration.openURLString = model.adUrl;
            //广告显示完成动画
            imageAdconfiguration.showFinishAnimate =ShowFinishAnimateFadein;
            //广告显示完成动画时间
            imageAdconfiguration.showFinishAnimateTime = 0.8;
            //跳过按钮类型
            imageAdconfiguration.skipButtonType = SkipTypeTimeText;
            //后台返回时,是否显示广告
            imageAdconfiguration.showEnterForeground = NO;
            
            //显示开屏广告
            [XHLaunchAd imageAdWithImageAdConfiguration:imageAdconfiguration delegate:self];
        }
    }];
}



#pragma mark - XHLaunchAdDelegate
- (void)xhLaunchAd:(XHLaunchAd *)launchAd clickAndOpenURLString:(NSString *)openURLString {
    UINavigationController *nav = nil;
    UIViewController *rootVc = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([rootVc isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabVc = (UITabBarController *)rootVc;
        nav = (UINavigationController *)[tabVc selectedViewController];
    }
    
    if (!nav || !self.adModel) {
        return;
    }
    
    [TDADHandler pushWithAdModel:self.adModel inNav:nav];
}
@end
