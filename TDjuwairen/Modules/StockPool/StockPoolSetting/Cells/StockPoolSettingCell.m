//
//  StockPoolSettingCell.m
//  TDjuwairen
//
//  Created by ZYP-MAC on 2017/8/11.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "StockPoolSettingCell.h"
#import "Masonry.h"
#import "UIView+Border.h"


@implementation StockPoolSettingCell

+ (CGFloat)loadStockPoolSettingCellHeight:(NSString *)descStr {
    if (descStr.length <= 0) {
        return 44;
    }
    CGFloat strH = [descStr calculateSize:CGSizeMake(kScreenWidth-30, CGFLOAT_MAX) font:[UIFont systemFontOfSize:15.0]].height;
    return strH+44+30;
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _sTitleLabel = [[UILabel alloc] init];
        _sTitleLabel.font = [UIFont systemFontOfSize:15.0];
        _sTitleLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#030303"];
        [self.contentView addSubview:_sTitleLabel];
        [_sTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15);
            make.top.equalTo(self.contentView);
            make.height.mas_equalTo(44);
            
        }];
        
        
        UIImageView * imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_arrow"]];
        [self.contentView addSubview:imgV];
        [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).mas_offset(-15);
            make.centerY.equalTo(_sTitleLabel.mas_centerY);
        }];
        
        _billingLabel = [[UILabel alloc] init];
        _billingLabel.font = [UIFont systemFontOfSize:15.0];
        _billingLabel.textColor = TDDetailTextColor;
        _billingLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_billingLabel];
        [_billingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(imgV.mas_left).mas_offset(-5);
            make.centerY.equalTo(_sTitleLabel.mas_centerY);
        }];
        
        
        _sSwitch = [[UISwitch alloc] init];
        _sSwitch.hidden = YES;
        _sSwitch.tintColor = [UIColor hx_colorWithHexRGBAString:@"#e4e4e4"];
        _sSwitch.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#e4e4e4"];
        [_sSwitch cutCircular:_sSwitch.bounds.size.height / 2.0];
        [_sSwitch addTarget:self action:@selector(changeBillingTypeClick:) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:_sSwitch];
        [_sSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).mas_offset(-15);
            make.centerY.equalTo(_sTitleLabel.mas_centerY);
        }];
        
        
        
        _sDescTextView = [[UITextView alloc] init];
        _sDescTextView.font = [UIFont systemFontOfSize:15.0];
        _sDescTextView.editable = NO;
        _sDescTextView.textColor = TDDetailTextColor;
        [self.contentView addSubview:_sDescTextView];
        [_sDescTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_sTitleLabel.mas_left);
            make.right.equalTo(imgV.mas_right);
            make.top.equalTo(_sTitleLabel.mas_bottom);
            make.bottom.equalTo(self.contentView);
        }];
    }
    return self;
}


#pragma - action
- (void)changeBillingTypeClick:(UISwitch *)sender {
    if (self.changeBillingBlock) {
        self.changeBillingBlock();
    }
}

@end
