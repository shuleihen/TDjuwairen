//
//  StockPoolRecordDateView.m
//  TDjuwairen
//
//  Created by ZYP-MAC on 2017/8/10.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "StockPoolRecordDateView.h"
#import "Masonry.h"


@interface StockPoolRecordDateView ()
/// 天label
@property (strong, nonatomic) UILabel *dayLabel;
/// 周几
@property (strong, nonatomic) UILabel *weekLabel;
/// 日期
@property (strong, nonatomic) UILabel *dateLabel;

@end

@implementation StockPoolRecordDateView

- (instancetype)init {

    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        
        
        UIView *arcView = [[UIView alloc] init];
        arcView.backgroundColor = TDLineColor;
        arcView.layer.cornerRadius = 3.5;
        arcView.layer.masksToBounds = YES;
        [self addSubview:arcView];
        [arcView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(24);
            make.right.equalTo(self);
            make.width.mas_equalTo(9);
            make.height.mas_equalTo(9);
            
        }];
        
        UIView *line1 = [[UIView alloc] init];
        line1.backgroundColor = TDLineColor;
        [self addSubview:line1];
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.centerX.equalTo(arcView.mas_centerX);
            make.width.mas_equalTo(1);
            make.height.mas_equalTo(24);
            
        }];
        
        
        UIView *line2 = [[UIView alloc] init];
        line2.backgroundColor = TDLineColor;
        [self addSubview:line2];
        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(arcView.mas_bottom);
            make.bottom.equalTo(self);
            make.centerX.equalTo(arcView.mas_centerX);
            make.width.equalTo(line1.mas_width);
            
        }];
        
        
        // 周几
        _weekLabel = [[UILabel alloc] init];
        _weekLabel.textAlignment = NSTextAlignmentLeft;
        _weekLabel.textColor = TDDetailTextColor;
        _weekLabel.font = [UIFont systemFontOfSize:12.0];
        _weekLabel.text = @"周四";
        [self addSubview:_weekLabel];
        [_weekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(arcView.mas_centerY);
            make.right.equalTo(line1.mas_left).mas_offset(-5);
            make.width.mas_equalTo(26);
        }];
        
        
        // 天
        _dayLabel = [[UILabel alloc] init];
        _dayLabel.textAlignment = NSTextAlignmentRight;
        _dayLabel.textColor = TDTitleTextColor;
        _dayLabel.font = [UIFont systemFontOfSize:13.0];
        _dayLabel.text = @"10";
        [self addSubview:_dayLabel];
        [_dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_weekLabel.mas_bottom);
            make.left.equalTo(self).mas_offset(1);
            make.right.equalTo(_weekLabel.mas_left).mas_offset(-3);
        }];
        
        // 日期
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.textAlignment = NSTextAlignmentRight;
        _dateLabel.textColor = TDDetailTextColor;
        _dateLabel.font = [UIFont systemFontOfSize:10.0];
        _dateLabel.text = @"2017-08";
        [self addSubview:_dateLabel];
        [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).mas_offset(3);
            make.right.equalTo(_weekLabel.mas_right);
            make.top.equalTo(_weekLabel.mas_bottom);
            make.bottom.equalTo(self).mas_offset(-3);
            
        }];
        
    }
    
    return self;
}



@end
