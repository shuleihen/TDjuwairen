//
//  KeysNumberTableViewCell.m
//  TDjuwairen
//
//  Created by 团大 on 2016/11/2.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//
#import "KeysNumberTableViewCell.h"
#import "HexColors.h"

@implementation KeysNumberTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#5FA9E3"];
        [self setupUI];
    }
    return self;
}

- (void) setupUI{
    self.keysLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 100, 24)];
    self.keysLab.textColor = [UIColor whiteColor];
    self.keysLab.font = [UIFont boldSystemFontOfSize:18];
    self.keysLab.text = @"钥匙数量";
    
    self.keysImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 75, 19, 37)];
    [self.keysImg setImage:[UIImage imageNamed:@"keysWhite.png"]];
    self.keysImg.contentMode = UIViewContentModeScaleAspectFit;
    
    self.numLab = [[UILabel alloc] initWithFrame:CGRectMake(45, 75, 150, 37)];
    self.numLab.textColor = [UIColor whiteColor];
    self.numLab.font = [UIFont boldSystemFontOfSize:36];
    
    self.topupBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-15-50, 80, 50, 30)];
    self.topupBtn.layer.cornerRadius = 5;
    self.topupBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.topupBtn.layer.borderWidth = 1;
    [self.topupBtn setTitle:@"充值" forState:UIControlStateNormal];
    self.topupBtn.titleLabel.textColor = [UIColor whiteColor];
    self.topupBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.topupBtn addTarget:self action:@selector(clickTopUp:) forControlEvents:UIControlEventTouchUpInside];
    self.topupBtn.hidden = YES;
    
    [self addSubview:self.keysLab];
    [self addSubview:self.keysImg];
    [self addSubview:self.numLab];
    [self addSubview:self.topupBtn];
}

- (void)clickTopUp:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(chargePressed:)]) {
        [self.delegate chargePressed:sender];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
