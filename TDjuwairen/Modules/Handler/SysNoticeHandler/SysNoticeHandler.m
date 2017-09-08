//
//  SysNoticeHandler.m
//  TDjuwairen
//
//  Created by zdy on 2017/9/8.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "SysNoticeHandler.h"
#import "NetworkManager.h"
#import "SysNoticeViewController.h"
#import "STPopup.h"
#import "NSDate+Util.h"
#import "SettingHandler.h"

@implementation SysNoticeHandler
+ (void)showSysNotice {
    if ([SettingHandler isEverNotShowSysNotice]) {
        return;
    }
    
    NSInteger time = [SettingHandler getShowSysNoticTime];
    if ([NSDate isCurrentDayWithTimeInterval:time]) {
        return;
    }
    
    NetworkManager *ma = [[NetworkManager alloc] init];
    [ma GET:API_MessageSystemNotice parameters:nil completion:^(id date, NSError *error){
        if (!error) {
            NSString *notice = date[@"notice_text"];
            [SysNoticeHandler showSysNoticeWithText:notice];
        }
    }];
}

+ (void)showSysNoticeWithText:(NSString *)text {
    CGSize size = [text boundingRectWithSize:CGSizeMake(300-38, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.f]} context:nil].size;
 
    CGFloat h = size.height + 132;
    h = MIN(h, 400);
    
    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    SysNoticeViewController *vc = [[UIStoryboard storyboardWithName:@"Popup" bundle:nil] instantiateViewControllerWithIdentifier:@"SysNoticeViewController"];
    vc.contentSizeInPopup = CGSizeMake(300, h);
    vc.notice = text;
    
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:vc];
    popupController.navigationBarHidden = YES;
    popupController.containerView.layer.cornerRadius = 12;
    [popupController presentInViewController:root];
}
@end
