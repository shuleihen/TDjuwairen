//
//  KeysNumberTableViewCell.m
//  TDjuwairen
//
//  Created by 团大 on 2016/11/2.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//
#define backBlue [UIColor colorWithRed:95/255.0 green:169/255.0 blue:227/255.0 alpha:1.0]

#import "KeysNumberTableViewCell.h"

#import "LoginState.h"

#import "AFNetworking.h"
#import "NetworkDefine.h"

@implementation KeysNumberTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = backBlue;
        [self setupUI];
    }
    return self;
}

- (void) setupUI{
    self.keysLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 100, 24)];
    self.keysLab.textColor = [UIColor whiteColor];
    self.keysLab.font = [UIFont boldSystemFontOfSize:20];
    self.keysLab.text = @"钥匙数量";
    
    self.keysImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 75, 40, 50)];
    [self.keysImg setImage:[UIImage imageNamed:@"keysWhite"]];
    self.keysImg.contentMode = UIViewContentModeScaleAspectFit;
    
    self.numLab = [[UILabel alloc] initWithFrame:CGRectMake(70, 75, 150, 50)];
    self.numLab.textColor = [UIColor whiteColor];
    self.numLab.font = [UIFont boldSystemFontOfSize:48];
    
    self.topupBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-15-60, 80, 60, 40)];
    self.topupBtn.layer.cornerRadius = 5;
    self.topupBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.topupBtn.layer.borderWidth = 0.5;
    [self.topupBtn setTitle:@"充值" forState:UIControlStateNormal];
    self.topupBtn.titleLabel.textColor = [UIColor whiteColor];
    self.topupBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.topupBtn addTarget:self action:@selector(clickTopUp:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.keysLab];
    [self addSubview:self.keysImg];
    [self addSubview:self.numLab];
    [self addSubview:self.topupBtn];
}

- (void)clickTopUp:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(clickTopUp:)]) {
        [self.delegate clickTopUp:sender];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
