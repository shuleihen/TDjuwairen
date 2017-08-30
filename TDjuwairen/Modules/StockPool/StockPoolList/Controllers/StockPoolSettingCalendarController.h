//
//  StockPoolSettingCalendarController.h
//  TDjuwairen
//
//  Created by deng shu on 2017/8/12.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StockPoolSettingCalendarController;
@protocol StockPoolSettingCalendarControllerDelegate <NSObject>

- (void)chooseDateBack:(StockPoolSettingCalendarController *)vc date:(NSDate *)date;

@end
@interface StockPoolSettingCalendarController : UIViewController
@property (nonatomic, strong) NSString *startDate;
@property (copy, nonatomic) NSString *userID;
@property (nonatomic, weak) id<StockPoolSettingCalendarControllerDelegate> delegate;
@end
