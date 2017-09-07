//
//  CalenderYearMonthPickerView.m
//  TDjuwairen
//
//  Created by deng shu on 2017/8/13.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "CalenderYearMonthPickerView.h"
#import "UIButton+Align.h"
#import "Masonry.h"
#import "UILabel+TDLabel.h"

#define ViewBgColor SetColor(240, 240, 240, 1)

#define MAX_YEAR 2100
#define MIN_YEAR 1900
#define DateMinuter @"1900-01-01"
#define DateMaxYear @"2100-12-31"

#define screenWith  [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height
#define  WJRGBColor(x,y,z) [UIColor colorWithRed:x/255.0 green:y/255.0 blue:z/255.0 alpha:1.0];


@interface CalenderYearMonthPickerView()<UIPickerViewDataSource, UIPickerViewDelegate>
{
    NSMutableArray *yearArr;
    NSInteger yearRange;
    NSInteger startYear;
    NSInteger selectedYear;
    NSInteger selectedMonth;
    NSCalendar *calendar;
    //左边退出按钮
    UIButton *cancelButton;
    //右边的确定按钮
    UIButton *chooseButton;
    
}
@property (nonatomic, copy) NSArray *provinces;//请假类型
@property (nonatomic, copy) NSArray *selectedArray;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic,strong) NSString *string;
@end

@implementation CalenderYearMonthPickerView
- (id)init {
    if (self = [super init]) {
        self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, 210)];
        self.pickerView.backgroundColor = [UIColor whiteColor]
        ;
        self.pickerView.dataSource=self;
        self.pickerView.delegate=self;
        [self addSubview:self.pickerView];
        //盛放按钮的View
        
        UIView *upVeiw = [[UIView alloc] init];
        upVeiw.backgroundColor = [UIColor whiteColor];
        [self addSubview:upVeiw];
        [upVeiw mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
            make.height.mas_equalTo(40);
        }];
        
        UIView *lineV = [[UIView alloc] init];
        lineV.backgroundColor = TDLineColor;
        [upVeiw addSubview:lineV];
        [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(upVeiw);
            make.height.mas_equalTo(1);
        }];
        
        UILabel *titleLabel = [[UILabel alloc] initWithTitle:@"选择年月" textColor:TDTitleTextColor fontSize:14.0 textAlignment:NSTextAlignmentCenter];
        [upVeiw addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(upVeiw.mas_centerX);
            make.centerY.equalTo(upVeiw.mas_centerY);
            
        }];
        
        //左边的取消按钮
        cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton setImage:[UIImage imageNamed:@"ico_close"] forState:UIControlStateNormal];
        cancelButton.backgroundColor = [UIColor clearColor];
        [cancelButton setTitleColor:SetColor(71, 158, 243, 1.0) forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [upVeiw addSubview:cancelButton];
        [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(upVeiw);
            make.centerY.equalTo(upVeiw.mas_centerY);
            make.width.height.mas_equalTo(40);
        }];
        
        //右边的确定按钮
        chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [chooseButton setTitle:@"完成" forState:UIControlStateNormal];
        chooseButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        chooseButton.hitTestEdgeInsets = UIEdgeInsetsMake(-5, -20, -5, -5);
        chooseButton.backgroundColor = TDThemeColor;
        chooseButton.layer.cornerRadius = 13.5;
        chooseButton.layer.masksToBounds = YES;
        [chooseButton addTarget:self action:@selector(doneButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [upVeiw addSubview:chooseButton];
        [chooseButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(upVeiw).mas_offset(-15);
            make.centerY.equalTo(upVeiw.mas_centerY);
            make.height.mas_equalTo(27);
            make.width.mas_equalTo(60);
        }];
        
        
        
        NSCalendar *calendar0 = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        NSInteger unitFlags =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
        comps = [calendar0 components:unitFlags fromDate:[NSDate date]];
        
        startYear=[DateMinuter integerValue];
        
        yearRange= [DateMaxYear integerValue]-startYear+1;
        _string = [NSString stringWithFormat:@"%04ld%02ld",comps.year,comps.month];
        
        selectedYear=2000;
        selectedMonth=1;
    }
    return self;
}


#pragma mark - actions
- (void)doneButtonClick{
    
    if (_pickClickBlock) {
        _pickClickBlock(self,_index,_string,YES);
    }

}



- (void)cancelButtonClick {
    if (_pickClickBlock) {
        _pickClickBlock(self,_index,_string,NO);
    }
    
}

#pragma mark -- UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}


//确定每一列返回的东西
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
        {
            return yearRange;
        }
            break;
        case 1:
        {
            return 12;
        }
            break;
            
        default:
            break;
    }
    return 0;
}

#pragma mark -- UIPickerViewDelegate
//默认时间的处理
-(void)setCurDate:(NSDate *)curDate
{
    
    //获取当前时间
    NSCalendar *calendar0 = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    comps = [calendar0 components:unitFlags fromDate:curDate];
    NSInteger year=[comps year];
    NSInteger month=[comps month];
    
    selectedYear=year;
    selectedMonth=month;
    
    [self.pickerView selectRow:year-startYear inComponent:0 animated:true];
    [self.pickerView selectRow:month-1 inComponent:1 animated:true];
    
    [self.pickerView reloadAllComponents];
}


-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(screenWith*component/6.0, 0,screenWith/6.0, 30)];
    
    label.tag=component*100+row;
    label.textAlignment=NSTextAlignmentCenter;
    switch (component) {
        case 0:
        {
            label.frame=CGRectMake(5, 0,screenWith/4.0, 30);
            label.font=[UIFont systemFontOfSize:17.0];
            label.text=[NSString stringWithFormat:@"%ld年",(long)(startYear + row)];
        }
            break;
        case 1:
        {
            label.frame=CGRectMake(screenWith/4.0, 0, screenWith/8.0, 30);
            label.font=[UIFont systemFontOfSize:15.0];
            label.text=[NSString stringWithFormat:@"%ld月",(long)row+1];
        }
            break;
            
        default:
            break;
    }
    
    ((UIView *)[pickerView.subviews objectAtIndex:1]).backgroundColor = [UIColor clearColor];
    
    ((UIView *)[pickerView.subviews objectAtIndex:2]).backgroundColor = [UIColor clearColor];
    
    return label;
}

// 监听picker的滑动
- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0:
        {
            selectedYear= startYear + row;
        }
            break;
        case 1:
        {
            selectedMonth=row+1;
        }
            break;

            
        default:
            break;
    }

    _string =[NSString stringWithFormat:@"%04ld%02ld",selectedYear,selectedMonth];

}



#pragma mark -- show and hidden
- (void)showInView:(UIView *)view {
    [UIView animateWithDuration:0.2f animations:^{
        self.frame = CGRectMake(0, view.frame.size.height-230, view.frame.size.width, 230);
    } completion:^(BOOL finished) {
    }];
}



- (void)setIndex:(NSInteger)index
{
    _index = index;
}

#pragma mark -- setter getter
- (NSArray *)provinces {
    if (!_provinces) {
        self.provinces = [@[] mutableCopy];
    }
    return _provinces;
}

- (NSArray *)selectedArray {
    if (!_selectedArray) {
        self.selectedArray = [@[] mutableCopy];
    }
    return _selectedArray;
}




-(NSInteger)isAllDay:(NSInteger)year andMonth:(NSInteger)month
{
    int day=0;
    switch(month)
    {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
            day=31;
            break;
        case 4:
        case 6:
        case 9:
        case 11:
            day=30;
            break;
        case 2:
        {
            if(((year%4==0)&&(year%100!=0))||(year%400==0))
            {
                day=29;
                break;
            }
            else
            {
                day=28;
                break;
            }
        }
        default:
            break;
    }
    return day;
}



@end

