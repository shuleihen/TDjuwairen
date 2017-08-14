//
//  CalendarDatePickerController.m
//  TDjuwairen
//
//  Created by deng shu on 2017/8/13.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "CalendarDatePickerController.h"
#import "STPopup.h"
#import "Masonry.h"
#import "UILabel+TDLabel.h"
#import "UIView+Border.h"
#import "CalenderYearMonthPickerView.h"

@interface CalendarDatePickerController ()
@property (nonatomic, strong) CalenderYearMonthPickerView *datePicker;


@end

@implementation CalendarDatePickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _datePicker = [[CalenderYearMonthPickerView alloc] init];
    [self.view addSubview:_datePicker];
    [_datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self.view);
    }];
    _datePicker.curDate=[NSDate date];
    _datePicker.tag = 101;
    __weak typeof (self)weakSelf = self;
    _datePicker.pickClickBlock = ^(CalenderYearMonthPickerView *picker,NSInteger index,NSString *selectString,BOOL isDone){
        if (isDone == YES) {
            if ([weakSelf.delegate respondsToSelector:@selector(chooseDateBack:dateStr:)]) {
                [weakSelf.delegate chooseDateBack:weakSelf dateStr:selectString];
            }
        }
        [weakSelf closeBtnClick];
    };

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


#pragma mark - actons
- (void)closeBtnClick {
    [self.popupController dismiss];
}


@end
