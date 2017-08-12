//
//  StockPoolSettingCalendarController.m
//  TDjuwairen
//
//  Created by deng shu on 2017/8/12.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "StockPoolSettingCalendarController.h"
#import "JTCalendar.h"
#import "Masonry.h"
#import "UIView+Border.h"


@interface StockPoolSettingCalendarController ()<JTCalendarDelegate>{
    NSMutableDictionary *_eventsByDate;
    
    NSDate *_todayDate;
    NSDate *_minDate;
    NSDate *_maxDate;
    
    NSDate *_dateSelected;
}

@property (strong, nonatomic) JTCalendarMenuView *calendarMenuView;
@property (strong, nonatomic) JTHorizontalCalendarView *calendarContentView;
@property (strong, nonatomic) JTCalendarManager *calendarManager;

@property (nonatomic, strong) UIButton *leftCalendarBtn;
@property (nonatomic, strong) UIButton *rightCalendarBtn;
@property (nonatomic, strong) UIButton *backTodayBtn;


@end

@implementation StockPoolSettingCalendarController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"日历";
    self.view.backgroundColor = [UIColor whiteColor];
    [self configCommonUI];
    
    [self createRandomEvents];
    _calendarManager = [JTCalendarManager new];
    _calendarManager.settings.weekDayFormat = JTCalendarWeekDayFormatSingle;
    _calendarManager.dateHelper.calendar.locale = [NSLocale localeWithLocaleIdentifier:@"zh-Hans"];
    _calendarManager.delegate = self;
    [_calendarManager setMenuView:_calendarMenuView];
    [_calendarManager setContentView:_calendarContentView];
    [self createMinAndMaxDate];
    [_calendarManager setDate:_todayDate];
    
    
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}


- (void)configCommonUI {
    self.calendarMenuView = [[JTCalendarMenuView alloc] init];
    [self.view addSubview:self.calendarMenuView];
    [self.calendarMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(64);
        make.width.mas_equalTo(140);
    }];
    
    
    _leftCalendarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_leftCalendarBtn setImage:[UIImage imageNamed:@"button_prev"]  forState:UIControlStateNormal];
    [_leftCalendarBtn addTarget:self action:@selector(prevMonthClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_leftCalendarBtn];
    [_leftCalendarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.calendarMenuView.mas_left).mas_offset(-14);;
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
        make.centerY.equalTo(self.calendarMenuView.mas_centerY);
    }];
    
    
    _rightCalendarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightCalendarBtn setImage:[UIImage imageNamed:@"button_next"] forState:UIControlStateNormal];
    [self.view addSubview:_rightCalendarBtn];
    [_rightCalendarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.calendarMenuView.mas_right).mas_offset(14);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
        make.centerY.equalTo(self.calendarMenuView.mas_centerY);
    }];
    
    
    
    self.calendarContentView = [[JTHorizontalCalendarView alloc] init];
    [self.view addSubview:self.calendarContentView];
    [_calendarContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.calendarMenuView.mas_bottom);
        make.left.equalTo(self.view).mas_offset(1);
        make.right.equalTo(self.view).mas_offset(-1);
        make.height.mas_equalTo(324);
    }];
    
    
    _backTodayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backTodayBtn setTitle:@"回到今天" forState:UIControlStateNormal];
    [_backTodayBtn setTitleColor:TDThemeColor forState:UIControlStateNormal];
    _backTodayBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [_backTodayBtn cutCircular:13.5];
    [_backTodayBtn addBorder:1 borderColor:TDThemeColor];
    [_backTodayBtn addTarget:self action:@selector(backTodayBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backTodayBtn];
    [_backTodayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.calendarContentView.mas_bottom).mas_offset(25);;
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(27);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
}


#pragma mark - actions
- (void)backTodayBtnClick {
    [_calendarManager setDate:_todayDate];
}

/** 上一个月 */
- (void)prevMonthClick {


}

#pragma mark - CalendarManager delegate
- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
     [dayView addBorder:1 borderColor:[UIColor whiteColor]];
    // Today
    if([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
        dayView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#F3FBFF"];
        [dayView addBorder:1 borderColor:TDThemeColor];
        dayView.textLabel.textColor = TDThemeColor;
        dayView.textLabel.text = [NSString stringWithFormat:@"%@\n今天",dayView.textLabel.text];
    }
    // Selected date
    else if(_dateSelected && [_calendarManager.dateHelper date:_dateSelected isTheSameDayThan:dayView.date]){
        dayView.backgroundColor = TDThemeColor;
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Other month
    else if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
       
        dayView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#FAFDFE"];
        dayView.textLabel.textColor = TDAssistTextColor;
       
    }
    // Another day of the current month
    else{
     
        dayView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#F3FBFF"];
        dayView.textLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#797979"];
    }
    
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    _dateSelected = dayView.date;
    
    // Animation for the circleView
  
    [UIView transitionWithView:dayView
                      duration:.3
                       options:0
                    animations:^{
                       
                        [_calendarManager reload];
                    } completion:nil];
    
    
    // Don't change page in week mode because block the selection of days in first and last weeks of the month
    if(_calendarManager.settings.weekModeEnabled){
        return;
    }
    
    // Load the previous or next page if touch a day from another month
    
    if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        if([_calendarContentView.date compare:dayView.date] == NSOrderedAscending){
            [_calendarContentView loadNextPageWithAnimation];
        }
        else{
            [_calendarContentView loadPreviousPageWithAnimation];
        }
    }
}

#pragma mark - CalendarManager delegate - Page mangement
- (void)calendar:(JTCalendarManager *)calendar prepareMenuItemView:(UILabel *)menuItemView date:(NSDate *)date
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"yyyy年MM月";
        
        dateFormatter.locale = _calendarManager.dateHelper.calendar.locale;
        dateFormatter.timeZone = _calendarManager.dateHelper.calendar.timeZone;
    }
    menuItemView.font = [UIFont systemFontOfSize:24.0];
    menuItemView.textColor = [UIColor hx_colorWithHexRGBAString:@"#818181"];

    menuItemView.text = [dateFormatter stringFromDate:date];
}



// Used to limit the date for the calendar, optional
- (BOOL)calendar:(JTCalendarManager *)calendar canDisplayPageWithDate:(NSDate *)date
{
    return [_calendarManager.dateHelper date:date isEqualOrAfter:_minDate andEqualOrBefore:_maxDate];
}

- (void)calendarDidLoadNextPage:(JTCalendarManager *)calendar
{
    //    NSLog(@"Next page loaded");
}

- (void)calendarDidLoadPreviousPage:(JTCalendarManager *)calendar
{
    //    NSLog(@"Previous page loaded");
}

#pragma mark - Fake data
- (void)createMinAndMaxDate
{
    _todayDate = [NSDate date];
    
    // Min date will be 2 month before today
    _minDate = [_calendarManager.dateHelper addToDate:_todayDate months:-2];
    
    // Max date will be 2 month after today
    _maxDate = [_calendarManager.dateHelper addToDate:_todayDate months:2];
}

// Used only to have a key for _eventsByDate
- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"dd-MM-yyyy";
    }
    
    return dateFormatter;
}

- (BOOL)haveEventForDay:(NSDate *)date
{
    NSString *key = [[self dateFormatter] stringFromDate:date];
    
    if(_eventsByDate[key] && [_eventsByDate[key] count] > 0){
        return YES;
    }
    
    return NO;
    
}

- (void)createRandomEvents
{
    _eventsByDate = [NSMutableDictionary new];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd";

}


@end

