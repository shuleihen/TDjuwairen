//
//  StockPoolSubscibeCell.m
//  TDjuwairen
//
//  Created by deng shu on 2017/8/12.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "StockPoolSubscibeCell.h"
#import "Masonry.h"
#import "UILabel+TDLabel.h"
#import "UIView+Border.h"
#import "StockPoolSubscibeModel.h"
#import "UIImageView+WebCache.h"

@interface StockPoolSubscibeCell ()
/// 头像
@property (nonatomic, strong) UIImageView *sIconImageV;
/// title
@property (nonatomic, strong) UILabel *sNickNameLabel;
/// 描述
@property (nonatomic, strong) UILabel *sDescLabel;
/// 关注button
@property (nonatomic, strong) UIButton *sAttentionBtn;
/// 日期
@property (nonatomic, strong) UILabel *sTimeLabel;

@end

@implementation StockPoolSubscibeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _sIconImageV = [[UIImageView alloc] init];
        _sIconImageV.backgroundColor = [UIColor yellowColor];
        [_sIconImageV cutCircular:25];
        [self.contentView addSubview:_sIconImageV];
        [_sIconImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(12);
            make.top.equalTo(self.contentView).mas_offset(10);
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(50);
        }];
        
        _sAttentionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sAttentionBtn setBackgroundColor:TDThemeColor];
        _sAttentionBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [_sAttentionBtn addTarget:self action:@selector(attentionBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_sAttentionBtn];
        [_sAttentionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).mas_offset(-12);
            make.top.equalTo(_sIconImageV.mas_top);
            make.width.mas_equalTo(64);
            make.height.mas_equalTo(24);
        }];
        
        _sNickNameLabel = [[UILabel alloc] initWithTextColor:TDTitleTextColor fontSize:16.0 textLine:1];
        _sNickNameLabel.text = @"学习范";
        [self.contentView addSubview:_sNickNameLabel];
        [_sNickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_sIconImageV.mas_right).mas_offset(10);
            make.top.equalTo(_sIconImageV.mas_top);
            make.right.equalTo(_sAttentionBtn.mas_left).mas_offset(-10);
        }];
        
        _sTimeLabel = [[UILabel alloc] initWithTextColor:[UIColor hx_colorWithHexRGBAString:@"#FF6C00"] fontSize:12.0 textLine:1];
        _sTimeLabel.text = @"剩余13天";
        [self.contentView addSubview:_sTimeLabel];
        [_sTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_sNickNameLabel.mas_left);
            make.bottom.equalTo(self.contentView).mas_offset(-9);
            make.right.equalTo(_sAttentionBtn.mas_right);
        }];
        
        _sDescLabel = [[UILabel alloc] initWithTextColor:TDLightGrayColor fontSize:14.0 textLine:1];
        _sDescLabel.text = @"孤独的价值投资人，伪价值投资者注意，孤独...";
        [self.contentView addSubview:_sDescLabel];
        [_sDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_sNickNameLabel.mas_left);
            make.bottom.equalTo(_sTimeLabel.mas_top).mas_offset(-12);
            make.right.equalTo(_sAttentionBtn.mas_right);
        }];    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (void)setModel:(StockPoolSubscibeModel *)model {
    
    _model = model;
    _sNickNameLabel.text = model.user_nickname;
    _sDescLabel.text = model.userinfo_info;
    _sTimeLabel.text = model.expire_day;
    if (model.has_atten == YES) {
        /// 已关注
        [_sAttentionBtn setTitleColor:TDThemeColor forState:UIControlStateNormal];
        [_sAttentionBtn setBackgroundColor:[UIColor whiteColor]];
        [_sAttentionBtn setTitle:@"已关注" forState:UIControlStateNormal];
        
    }else {
        [_sAttentionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sAttentionBtn setBackgroundColor:TDThemeColor];
         [_sAttentionBtn setTitle:@"加关注" forState:UIControlStateNormal];
    }
    //     [_sIconImageV sd_setImageWithURL:[NSURL URLWithString:model.plat_logo] placeholderImage:TDDefaultUserAvatar];
    
}


#pragma  mark - 按钮点击事件
- (void)attentionBtnClick {
    if (_model == nil) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(attentionAction:subscibeModel:)]) {
        [self.delegate attentionAction:self subscibeModel:self.model];
    }
    
}

@end
