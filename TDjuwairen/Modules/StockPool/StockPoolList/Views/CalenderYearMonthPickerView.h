//
//  CalenderYearMonthPickerView.h
//  TDjuwairen
//
//  Created by deng shu on 2017/8/13.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#define MAX_YEAR 2100
#define MIN_YEAR 1900

@class CalenderYearMonthPickerView;

typedef void(^pickerBlock)(CalenderYearMonthPickerView *picker,NSInteger currentIndex,NSString *inputString,BOOL isDone);


@interface CalenderYearMonthPickerView : UIView
@property (nonatomic, copy) NSString *province;
@property(nonatomic,strong)NSDate*curDate;
@property (nonatomic,strong)UITextField *myTextField;

@property (nonatomic,assign)NSInteger index;

@property (nonatomic,copy)NSString *minTimeString;

@property (nonatomic, copy) pickerBlock pickClickBlock;
@end
