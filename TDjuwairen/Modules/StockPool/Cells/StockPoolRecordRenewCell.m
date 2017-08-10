//
//  StockPoolRecordRenewCell.m
//  TDjuwairen
//
//  Created by ZYP-MAC on 2017/8/10.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "StockPoolRecordRenewCell.h"
#import "StockPoolRecordDateView.h"
#import "Masonry.h"
#import "UIView+Border.h"

@interface StockPoolRecordRenewCell ()
/// 日期view
@property (strong, nonatomic) StockPoolRecordDateView *dateView;
/// 续费按钮
@property (strong, nonatomic) UIButton *renewButton;



@end

@implementation StockPoolRecordRenewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _dateView = [[StockPoolRecordDateView alloc] init];
        [self.contentView addSubview:_dateView];
        [_dateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self);
            make.width.mas_equalTo(68.5);
            make.height.equalTo(self);
        }];
        
        UILabel *desLabel = [[UILabel alloc] init];
        desLabel.textAlignment = NSTextAlignmentLeft;
        desLabel.font = [UIFont systemFontOfSize:15.0];
        desLabel.textColor = TDLightGrayColor;
        desLabel.text = @"到期";
        [self.contentView addSubview:desLabel];
        [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_dateView.mas_right).mas_offset(15);
            make.top.equalTo(self).mas_offset(16.5);
            make.width.mas_equalTo(40);
            
        }];
        
        _renewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_renewButton setTitle:@"续费" forState:UIControlStateNormal];
        _renewButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_renewButton cutCircular:14];
        [_renewButton setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"#FF523B"]];
        [_renewButton addTarget:self action:@selector(renewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_renewButton];
        [_renewButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).mas_offset(-12.3);
            make.centerY.equalTo(desLabel.mas_centerY);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(28);
        }];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = TDLineColor;
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(desLabel.mas_centerY);
            make.left.equalTo(desLabel.mas_right);
            make.right.equalTo(_renewButton.mas_left).offset(-10);
            make.height.mas_equalTo(1);
        }];
        
    }
    return  self;
}

#pragma - 续费按钮点击事件
- (void)renewButtonClick:(UIButton *)sender {

    
}

@end
