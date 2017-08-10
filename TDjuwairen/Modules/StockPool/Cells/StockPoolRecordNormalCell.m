//
//  StockPoolRecordNormalCell.m
//  TDjuwairen
//
//  Created by ZYP-MAC on 2017/8/10.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "StockPoolRecordNormalCell.h"
#import "StockPoolRecordDateView.h"
#import "Masonry.h"
#import "UIView+Border.h"

@interface StockPoolRecordNormalCell ()
/// 日期view
@property (strong, nonatomic) StockPoolRecordDateView *dateView;
@property (strong, nonatomic) UILabel *sTitleLabel;
@property (strong, nonatomic) UILabel *sMoneyLabel;
@property (strong, nonatomic) UIProgressView *sProgressView;
@property (strong, nonatomic) UILabel *sDesLabel;
@property (strong, nonatomic) UILabel *sTimeLabel;

@end

@implementation StockPoolRecordNormalCell

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
        
        UIView *whiteBGView = [[UIView alloc] init];
        whiteBGView.backgroundColor = [UIColor whiteColor];
        [whiteBGView cutCircular:2];
        [self.contentView addSubview:whiteBGView];
        [whiteBGView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).mas_offset(17);
            make.left.equalTo(_dateView.mas_right).mas_offset(5);
            make.right.equalTo(self).mas_offset(-16.4);
            make.bottom.equalTo(self);
            
        }];
        
        /// 资金
        _sMoneyLabel = [[UILabel alloc] init];
        _sMoneyLabel.font = [UIFont systemFontOfSize:14.0];
        _sMoneyLabel.textColor = TDLightGrayColor;
        _sMoneyLabel.text = @"30% 资金";
        [whiteBGView addSubview:_sMoneyLabel];
        [_sMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(whiteBGView).mas_offset(11);
            make.right.equalTo(whiteBGView).mas_offset(-10);
            
        }];
        
        
        /// 仓位
        _sTitleLabel = [[UILabel alloc] init];
        _sTitleLabel.font = [UIFont systemFontOfSize:14.0];
        _sTitleLabel.textColor = TDLightGrayColor;
        _sTitleLabel.text = @"仓位 70%";
        [whiteBGView addSubview:_sTitleLabel];
        [_sTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(whiteBGView).mas_offset(11);
            make.left.equalTo(whiteBGView).mas_offset(10);
            
        }];
        
        
        /// 进度
        _sProgressView = [[UIProgressView alloc] init];
        _sProgressView.progress = 0.5;
#warning - 渐变色设置
        _sProgressView.progressTintColor = [UIColor blueColor];
        _sProgressView.trackTintColor = [UIColor hx_colorWithHexRGBAString:@"#F0EFF2"];
        [whiteBGView addSubview:_sProgressView];
        [_sProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_sTitleLabel.mas_bottom).mas_offset(10);
            make.height.mas_equalTo(11);
            make.left.equalTo(_sTitleLabel.mas_left);
            make.right.equalTo(_sMoneyLabel.mas_right);
        }];
        
        /// 描述
        _sDesLabel = [[UILabel alloc] init];
        _sDesLabel.font = [UIFont systemFontOfSize:15.0];
        _sDesLabel.textColor = TDTitleTextColor;
        _sDesLabel.text = @"这两只杠杆基金，看好理由很简单。货比宽松，利好有色金属，今年内…";
        _sDesLabel.numberOfLines = 2;
        [whiteBGView addSubview:_sDesLabel];
        [_sDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_sProgressView.mas_bottom).mas_offset(11);
            make.left.equalTo(_sTitleLabel.mas_left);
            make.right.equalTo(_sMoneyLabel.mas_right);
            
        }];
        
        
        /// 时间
        _sTimeLabel = [[UILabel alloc] init];
        _sTimeLabel.font = [UIFont systemFontOfSize:12.0];
        _sTimeLabel.textColor = TDDetailTextColor;
        _sTimeLabel.text = @"09:51";
        [whiteBGView addSubview:_sTimeLabel];
        [_sTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(whiteBGView).mas_offset(-12);
            make.left.equalTo(whiteBGView).mas_offset(10);
            
        }];
        
        
    }
    return self;
}


@end
