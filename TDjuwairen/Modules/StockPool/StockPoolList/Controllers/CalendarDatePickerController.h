//
//  CalendarDatePickerController.h
//  TDjuwairen
//
//  Created by deng shu on 2017/8/13.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CalendarDatePickerController;

@protocol CalendarDatePickerControllerDelegate <NSObject>

- (void)chooseDateBack:(CalendarDatePickerController *)vc dateStr:(NSString *)str;

@end

@interface CalendarDatePickerController : UIViewController
@property (nonatomic, weak) id<CalendarDatePickerControllerDelegate> delegate;
@end
