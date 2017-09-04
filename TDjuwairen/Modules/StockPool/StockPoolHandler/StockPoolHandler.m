//
//  StockPoolHandler.m
//  TDjuwairen
//
//  Created by zdy on 2017/8/22.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "StockPoolHandler.h"
#import "SettingHandler.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@implementation StockPoolHandler

+ (void)setupStockPoolLocalNotifi {
    
    if (NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_9_x_Max) { 
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        content.title = @"定时清空每天发布股票池记录数";
        content.subtitle = @"";
        content.body = @"";
        
        //第三步：通知触发机制。（重复提醒，时间间隔要大于60s）
        NSDateComponents *com = [[NSDateComponents alloc] init];
        com.hour = 15;
        com.minute = 11;
        
        UNCalendarNotificationTrigger *trigger1 = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:com repeats:YES];
        
        //第四步：创建UNNotificationRequest通知请求对象
        NSString *requertIdentifier = @"jwr.stockpool";
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requertIdentifier content:content trigger:trigger1];
        
        //第五步：将通知加到通知中心
        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            
        }];
    }else
    {
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        if (localNotification == nil) {
            return;
        }
        
        //设置UILocalNotification
        [localNotification setTimeZone:[NSTimeZone defaultTimeZone]];//设置时区
        localNotification.fireDate = [NSDate dateWithTimeIntervalSince1970:4*60*60];//设置触发时间
        localNotification.repeatInterval = kCFCalendarUnitDay;//设置重复间隔
        
        localNotification.alertBody = @"";
        localNotification.alertTitle = @"定时清空每天发布股票池记录数";
        localNotification.hasAction = NO;
        localNotification.category = @"jwr.stockpool";
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
}

+ (BOOL)canPublishStockPoolRecord {
    BOOL can = NO;
    
    if ([SettingHandler getAddStockPoolRecordCountInOneDay] > 2) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"股票池每天只能发两次哦,等过了凌晨4点再来吧~\n或者您可以删除最新的记录重新发" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *done = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:done];
        
        UIViewController *vc =  [UIApplication sharedApplication].keyWindow.rootViewController;
        [vc presentViewController:alert animated:YES completion:nil];
        
    } else {
        can = YES;
    }
    
    return can;
}
@end
