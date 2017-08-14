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
#import "CalendarDatePickerController.h"
#import "STPopup.h"
#import "NetworkManager.h"


@interface StockPoolSettingCalendarController ()<JTCalendarDelegate,CalendarDatePickerControllerDelegate>{
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

/// 日期选择器View
@property (nonatomic, strong) CalendarDatePickerController *datePickerVC;

@property (nonatomic, strong) NSArray *dateArr;
@property (nonatomic, strong) NSDateFormatter *localDateFormatter;


@end

@implementation StockPoolSettingCalendarController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"日历";
    _dateArr = [NSArray array];
    _localDateFormatter = [[NSDateFormatter alloc] init];
    _localDateFormatter.dateFormat = @"yyyy-MM-dd";
    
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
    
    [self refeshCalendarDateWithDate:[NSDate date]];
    
    
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
    
    
    UITapGestureRecognizer *pickerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickerDateAction:)];
    [self.calendarMenuView addGestureRecognizer:pickerTap];
    
    
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
    [_rightCalendarBtn addTarget:self action:@selector(nextMonthClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_rightCalendarBtn];
    [_rightCalendarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.calendarMenuView.mas_right).mas_offset(14);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
        make.centerY.equalTo(self.calendarMenuView.mas_centerY);
    }];
    
    
    
    _calendarContentView = [[JTHorizontalCalendarView alloc] init];
    
    [self.view addSubview:_calendarContentView];
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
    
    
    _datePickerVC = [[CalendarDatePickerController alloc] init];
    _datePickerVC.delegate = self;
    
    
    
}


#pragma mark - actions
- (void)backTodayBtnClick {
    [_calendarManager setDate:_todayDate];
    [self refeshCalendarDateWithDate:_todayDate];
    
}

/** 上一个月 */
- (void)prevMonthClick {
    [_calendarContentView loadPreviousPageWithAnimation];
    
}

/** 下一个月 */
- (void)nextMonthClick {
    [_calendarContentView loadNextPageWithAnimation];
    
}

- (void)pickerDateAction:(UITapGestureRecognizer *)pickerDateTap {
    self.datePickerVC.contentSizeInPopup = CGSizeMake(kScreenWidth, 252.5);
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:self.datePickerVC];
    popupController.style = STPopupStyleBottomSheet;
    popupController.navigationBarHidden = YES;
    [popupController presentInViewController:self];
}


#pragma mark - 加载数据
/** 获取制定月份下的所有有记录的日期 */
- (void)loadRecordListWithMonthString:(NSString *)monthStr {
    //@"master_id":US.userId
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    /**
     month	string	年月	是	201708 月份为两位数字
     master_id	string	股票池所属用户ID	是
     */
    NSDictionary *dict = @{@"month":SafeValue(monthStr),@"master_id":US.userId};
    [manager GET:API_StockPoolGetRecordDates parameters:dict completion:^(NSArray *data, NSError *error) {
        if (!error) {
            NSMutableArray *tempArr = [NSMutableArray array];
            _localDateFormatter.dateFormat = @"yyyy-MM-dd";
            for (NSString *str in data) {
                NSDate *d = [self.localDateFormatter dateFromString:str];
                [tempArr addObject:d];
            }
            self.dateArr = [NSArray arrayWithArray:[tempArr mutableCopy]];
            [self.calendarManager reload];
            
        }
        
    }];
    
}

#pragma mark - CalendarDatePickerControllerDelegate
- (void)chooseDateBack:(CalendarDatePickerController *)vc dateStr:(NSString *)str {
    [self.localDateFormatter setDateFormat:@"yyyyMM"];
    NSDate *d= [self.localDateFormatter dateFromString:str];
    [self.localDateFormatter setDateFormat:@"yyyy年MM月"];
    [_calendarManager setDate:d];
    [self loadRecordListWithMonthString:str];
}

#pragma mark - CalendarManager delegate
- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    [dayView addBorder:1 borderColor:[UIColor whiteColor]];
    
    dayView.userInteractionEnabled = NO;
    dayView.haveDataImageView.hidden = YES;
    for (NSDate *sourceDate in self.dateArr) {
        if ([_calendarManager.dateHelper date:sourceDate isTheSameDayThan:dayView.date]) {
            dayView.haveDataImageView.hidden = NO;
            dayView.userInteractionEnabled = YES;
        }
    }
    
    
    if([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
        // Today
        dayView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#F3FBFF"];
        [dayView addBorder:1 borderColor:TDThemeColor];
        dayView.textLabel.textColor = TDThemeColor;
        dayView.textLabel.text = [NSString stringWithFormat:@"%@\n今天",dayView.textLabel.text];
    }
    else if(_dateSelected && [_calendarManager.dateHelper date:_dateSelected isTheSameDayThan:dayView.date]){
        // Selected date
        dayView.backgroundColor = TDThemeColor;
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    else if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        // Other month
        
        dayView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#FAFDFE"];
        dayView.textLabel.textColor = TDAssistTextColor;
        dayView.haveDataImageView.hidden = YES;
        
    }
    else{
        // Another day of the current month
        
        dayView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#F3FBFF"];
        dayView.textLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#797979"];
    }
    
    
    
    
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    _dateSelected = dayView.date;
    
    [UIView transitionWithView:dayView
                      duration:.3
                       options:0
                    animations:^{
                        
                        [_calendarManager reload];
                        
                    } completion:^(BOOL finished) {
                        if ([self.delegate respondsToSelector:@selector(chooseDateBack:dateStr:)]) {
                            _localDateFormatter.dateFormat = @"yyyy-MM";
                            
                            NSCalendar *calendar = [NSCalendar currentCalendar];
                            NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:dayView.date];
                            [self.delegate chooseDateBack:self dateStr:[NSString stringWithFormat:@"%04ld%02ld",[components year],[components month]]];
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                    }];
    
    
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
//- (BOOL)calendar:(JTCalendarManager *)calendar canDisplayPageWithDate:(NSDate *)date
//{
//    return [_calendarManager.dateHelper date:date isEqualOrAfter:_minDate andEqualOrBefore:_maxDate];
//}

- (void)calendarDidLoadNextPage:(JTCalendarManager *)calendar
{
    
    [self refeshCalendarDateWithDate:calendar.date];
}

- (void)calendarDidLoadPreviousPage:(JTCalendarManager *)calendar
{
   
    [self refeshCalendarDateWithDate:calendar.date];
}

- (void)refeshCalendarDateWithDate:(NSDate *)date {
    
    NSCalendar *calendars = [NSCalendar currentCalendar];
    NSDateComponents *componentsMonth = [calendars components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:date];
    NSString *searchMonthStr = [NSString stringWithFormat:@"%04ld%02ld",componentsMonth.year,componentsMonth.month];
    [self loadRecordListWithMonthString:searchMonthStr];
    
}

#pragma mark - Fake data
- (void)createMinAndMaxDate
{
    _todayDate = [NSDate date];
    
    // Min date will be 2 month before today
//    _minDate = [_calendarManager.dateHelper addToDate:_todayDate months:-2];
    
    // Max date will be 2 month after today
//    _maxDate = [_calendarManager.dateHelper addToDate:_todayDate months:2];
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

