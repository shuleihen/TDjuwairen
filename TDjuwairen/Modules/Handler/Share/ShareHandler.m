//
//  ShareHandler.m
//  TDjuwairen
//
//  Created by zdy on 2017/1/19.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "ShareHandler.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "MBProgressHUD.h"

@implementation ShareHandler


+ (void)shareWithTitle:(NSString *)title image:(NSString *)image url:(NSURL *)url {
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray *images;
    if (image) {
        images = @[image];
    }
    
    [shareParams SSDKSetupShareParamsByText:nil images:images url:url title:title type:SSDKContentTypeAuto];
    
    [ShareSDK showShareActionSheet:nil
                             items:nil
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   if (state == SSDKResponseStateSuccess) {
                       UIWindow *window = [UIApplication sharedApplication].keyWindow;
                       MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
                       hud.mode = MBProgressHUDModeText;
                       hud.animationType = MBProgressHUDAnimationZoomIn;
                       hud.labelText = @"分享成功";
                       hud.removeFromSuperViewOnHide = YES;
                       [hud hide:YES afterDelay:0.4];
                       
                   } else if (state == SSDKResponseStateFail) {
                       UIWindow *window = [UIApplication sharedApplication].keyWindow;
                       MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
                       hud.mode = MBProgressHUDModeText;
                       hud.animationType = MBProgressHUDAnimationZoomIn;
                       hud.labelText = @"分享失败";
                       hud.removeFromSuperViewOnHide = YES;
                       [hud hide:YES afterDelay:0.4];
                   }
               }];
}

+ (void)shareWithTitle:(NSString *)title image:(NSArray *)images url:(NSString *)url shareState:(void(^)(BOOL state))stateBlock  {
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];

    [shareParams SSDKSetupShareParamsByText:nil images:images url:[NSURL URLWithString:SafeValue(url)] title:title type:SSDKContentTypeAuto];
    
    [ShareSDK showShareActionSheet:nil
                             items:nil
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   if (state == SSDKResponseStateSuccess) {
                       UIWindow *window = [UIApplication sharedApplication].keyWindow;
                       MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
                       hud.mode = MBProgressHUDModeText;
                       hud.animationType = MBProgressHUDAnimationZoomIn;
                       hud.labelText = @"分享成功";
                       hud.removeFromSuperViewOnHide = YES;
                       [hud hide:YES afterDelay:0.4];
                       
                   } else if (state == SSDKResponseStateFail) {
                       UIWindow *window = [UIApplication sharedApplication].keyWindow;
                       MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
                       hud.mode = MBProgressHUDModeText;
                       hud.animationType = MBProgressHUDAnimationZoomIn;
                       hud.labelText = @"分享失败";
                       hud.removeFromSuperViewOnHide = YES;
                       [hud hide:YES afterDelay:0.4];
                   }
                   stateBlock(state == SSDKResponseStateSuccess);
               }];
}
@end
