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
#import "ShareViewController.h"
#import "STPopup.h"

@implementation ShareHandler


+ (void)shareWithTitle:(NSString *)title image:(NSString *)image url:(NSURL *)url {
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray *images;
    if (image) {
        images = @[image];
    }
    
    NSArray *imageArray;
    if (images.count == 0) {
        imageArray = @[[UIImage imageNamed:@"app_icon.png"]];
    } else {
        imageArray = images;
    }
    
    [shareParams SSDKSetupShareParamsByText:nil images:imageArray url:url title:title type:SSDKContentTypeAuto];
    
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

+ (void)shareWithTitle:(NSString *)title image:(NSArray *)images url:(NSString *)url selectedBlock:(void(^)(NSInteger index))selectedBlock shareState:(void(^)(BOOL state))stateBlock  {
    
    ShareViewController *vc = [[UIStoryboard storyboardWithName:@"Popup" bundle:nil] instantiateViewControllerWithIdentifier:@"ShareViewController"];
    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController;
    if (!root) {
        root = [UIApplication sharedApplication].keyWindow.rootViewController;
    }
    
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:vc];
    popupController.style = STPopupStyleBottomSheet;
    popupController.navigationBarHidden = YES;
    [popupController presentInViewController:root];
    
    
    void (^ShareWithType)(SSDKPlatformType type) = ^(SSDKPlatformType type){
        if (type == SSDKPlatformTypeUnknown) {
            return;
        }
        
        NSArray *imageArray;
        if (images.count == 0) {
            imageArray = @[[UIImage imageNamed:@"app_icon.png"]];
        } else {
            imageArray = images;
        }
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:nil
                                         images:imageArray
                                            url:[NSURL URLWithString:SafeValue(url)]
                                          title:title
                                           type:SSDKContentTypeAuto];
        
        //进行分享
        [ShareSDK share:type
             parameters:shareParams
         onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
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
    };
    
    vc.buttonClickBlock = ^(NSInteger index){
        SSDKPlatformType type;
        
        switch (index) {
            case 0:
                type = SSDKPlatformTypeUnknown;
                break;
            case 1:
                type = SSDKPlatformSubTypeWechatTimeline;
                break;
            case 2:
                type = SSDKPlatformSubTypeWechatSession;
                break;
            case 3:
                type = SSDKPlatformTypeSinaWeibo;
                break;
            case 4:
                type = SSDKPlatformSubTypeQQFriend;
                break;
            case 5:
                type = SSDKPlatformSubTypeQZone;
                break;
            default:
                break;
        }
        
        selectedBlock(type);
        ShareWithType(type);
    };
    
    /*
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
     */
}
@end
