//
//  ExchangeTableViewCell.m
//  TDjuwairen
//
//  Created by 团大 on 2016/11/24.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "ExchangeTableViewCell.h"

#import "Masonry.h"

#import "UIImageView+WebCache.h"
#import "NSString+Ext.h"
#import "HexColors.h"

@implementation ExchangeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.prizeImg = [[UIImageView alloc] init];
        self.prizeImg.contentMode = UIViewContentModeScaleAspectFit;
        //标题
        self.prizeLab = [[UILabel alloc] init];
        self.prizeLab.font = [UIFont systemFontOfSize:16];
        
        self.keysImg = [[UIImageView alloc] init];
        self.keysImg.image = [UIImage imageNamed:@"key_yellow"];
        self.keysImg.contentMode = UIViewContentModeScaleAspectFit;
        
        self.keysNum = [[UILabel alloc] init];
        self.keysNum.font = [UIFont systemFontOfSize:18];
        self.keysNum.textColor = [HXColor hx_colorWithHexRGBAString:@"#F2BA2C"];
        
        self.exchangeBtn = [[UIButton alloc] init];
        [self.exchangeBtn setTitle:@"兑换奖品" forState:UIControlStateNormal];
        self.exchangeBtn.layer.cornerRadius = 5;
        [self.exchangeBtn addTarget:self action:@selector(clickExchange:) forControlEvents:UIControlEventTouchUpInside];
        
        self.line = [[UILabel alloc] init];
        self.line.layer.borderWidth = 1;
        
        [self addSubview:self.prizeImg];
        [self addSubview:self.prizeLab];
        [self addSubview:self.keysImg];
        [self addSubview:self.keysNum];
        [self addSubview:self.exchangeBtn];
        [self addSubview:self.line];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setupWithDiction:(ExchangeModel *)model andIndexPath:(NSIndexPath *)indexPath{
    
    [self.prizeImg sd_setImageWithURL:[NSURL URLWithString:model.prize_app_img]];
    [self.prizeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(15);
        make.left.equalTo(self).with.offset(15);
        make.bottom.equalTo(self).with.offset(-15);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(100);
    }];
    
    self.prizeLab.text = model.prize_name;
    [self.prizeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(15);
        make.left.equalTo(self.prizeImg.mas_right).with.offset(15);
        make.right.equalTo(self).with.offset(-15);
        make.height.mas_equalTo(30);
    }];
    
    if (model.is_exchange) {
        [self.exchangeBtn setBackgroundColor:[HXColor hx_colorWithHexRGBAString:@"#F2BA2C"]];
        self.exchangeBtn.enabled = YES;
    }
    else
    {
        [self.exchangeBtn setBackgroundColor:[HXColor hx_colorWithHexRGBAString:@"#999999"]];
        self.exchangeBtn.enabled = NO;
    }
    self.exchangeBtn.tag = indexPath.row;
    [self.exchangeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-15);
        make.bottom.equalTo(self).with.offset(-15);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(40);
    }];
    
    NSString *num = model.prize_keynum;
    CGSize numsize = CGSizeMake(100, 40);
    numsize = [num calculateSize:numsize font:[UIFont systemFontOfSize:18]];
    self.keysNum.text = num;
    [self.keysNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.exchangeBtn.mas_left).with.offset(-10);
        make.bottom.equalTo(self).with.offset(-15);
        make.width.mas_equalTo(numsize.width);
        make.height.mas_equalTo(40);
    }];
    
    [self.keysImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.keysNum.mas_left).with.offset(-5);
        make.centerY.equalTo(self.keysNum);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(0);
        make.bottom.equalTo(self).with.offset(0);
        make.right.equalTo(self).with.offset(0);
        make.height.mas_equalTo(1);
    }];
}

- (void)clickExchange:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(clickToExchangePrize:)]) {
        [self.delegate clickToExchangePrize:sender];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
