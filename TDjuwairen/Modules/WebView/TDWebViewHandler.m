//
//  TDWebViewHandler.m
//  TDjuwairen
//
//  Created by zdy on 2017/7/19.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "TDWebViewHandler.h"
#import "TDWebViewController.h"
#import "LoginStateManager.h"
#import "NSString+Util.h"

@implementation TDWebViewHandler
+ (void)openURL:(NSString *)aUrl inNav:(UINavigationController *)nav {
    
    [TDWebViewHandler openURL:aUrl withUserMark:NO inNav:nav];
}

+ (void)openURL:(NSString *)aUrl withUserMark:(BOOL)mark inNav:(UINavigationController *)nav {
    if ([aUrl isEqualToString:@"https://www.juwairen.net/index.php/WxUser/vipShow"]){
        NSString *nickName = [US.nickName URLEncode]?:@"";
        NSString *avatar = [US.headImage URLEncode]?:@"";
        
        NSString *urlString= [NSString stringWithFormat:@"https://www.juwairen.net/index.php/WxUser/vipShow?user_name=%@&user_avatar=%@&user_islogin=%@&user_isvip=%@",nickName,avatar,@(US.isLogIn),@(US.userLevel)];
        NSURL *url = [NSURL URLWithString:urlString];
        if (url) {
            TDWebViewController *vc = [[TDWebViewController alloc] initWithURL:url];
            vc.hidesBottomBarWhenPushed = YES;
            [nav pushViewController:vc animated:YES];
        }
    } else {
        if (mark) {
            NSString *accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"unique_str"];
            aUrl = [aUrl stringByAppendingFormat:@"?unique_str=%@",accessToken];
        }
        
        NSURL *url = [NSURL URLWithString:aUrl];
        if (url) {
            TDWebViewController *vc = [[TDWebViewController alloc] initWithURL:url];
            vc.hidesBottomBarWhenPushed = YES;
            [nav pushViewController:vc animated:YES];
        }
    }
}
@end
