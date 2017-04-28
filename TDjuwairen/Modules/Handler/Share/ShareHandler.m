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
    
    
    void (^shareWithType)(SSDKPlatformType type) = ^(SSDKPlatformType type){
        if (type == SSDKPlatformTypeUnknown) {
            return;
        }
        
        NSArray *imageArray;
        if (images.count == 0) {
            imageArray = @[[UIImage imageNamed:@"app_icon.png"]];
        } else {
            imageArray = images;
        }
        
        NSString *shareTitle = @"";
        NSString *shareText = @"";
        
        if (type == SSDKPlatformSubTypeQQFriend ||
            type == SSDKPlatformSubTypeQZone) {
            /* url: 1、必须用域名网址 ； 2、url 不能含有中文；
             title：最多200个字符；
             text：最多600个字符；
            */
            if (title.length > 200) {
                shareTitle = [title substringToIndex:200];
            }
        } else if (type == SSDKPlatformTypeSinaWeibo) {
            // text：不能超过140个汉字
            NSInteger limit = 140 - url.length;
            
            if (title.length > limit) {
                shareText = [title substringToIndex:limit];
            } else {
                shareText = title;
            }
            
            // 微博分享需要将url 拼接到title后面
            shareText = [shareText stringByAppendingString:url];
        } else if (type == SSDKPlatformSubTypeWechatTimeline ||
                   type == SSDKPlatformSubTypeWechatSession) {
            /*  title：512Bytes以内
                description：1KB以内
             */
            if (title.length > 512) {
                shareTitle = [title substringToIndex:512];
            }
        }
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        if (type == SSDKPlatformTypeSinaWeibo) {
            [shareParams SSDKEnableAdvancedInterfaceShare];
        }
        
        [shareParams SSDKEnableUseClientShare];
        
        [shareParams SSDKSetupShareParamsByText:shareText
                                         images:imageArray
                                            url:[NSURL URLWithString:SafeValue(url)]
                                          title:shareTitle
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
                 [hud hide:YES afterDelay:0.6];
                 
             } else if (state == SSDKResponseStateFail) {
                 UIWindow *window = [UIApplication sharedApplication].keyWindow;
                 MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
                 hud.mode = MBProgressHUDModeText;
                 hud.animationType = MBProgressHUDAnimationZoomIn;
                 hud.labelText = @"分享失败";
                 hud.removeFromSuperViewOnHide = YES;
                 [hud hide:YES afterDelay:0.6];
             }
             
             if (stateBlock) {
                 stateBlock(state == SSDKResponseStateSuccess);
             }
             
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
                type = SSDKPlatformTypeUnknown;
                break;
        }
        
        if (selectedBlock) {
            selectedBlock(type);
        }
        
        if (shareWithType) {
            shareWithType(type);
        }
        
    };
}
@end
