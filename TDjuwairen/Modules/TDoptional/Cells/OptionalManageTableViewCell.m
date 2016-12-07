//
//  OptionalManageTableViewCell.m
//  TDjuwairen
//
//  Created by 团大 on 2016/12/7.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "OptionalManageTableViewCell.h"

#import "Masonry.h"

@implementation OptionalManageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIButton *delBtn = [[UIButton alloc] init];
        [delBtn setBackgroundImage:[UIImage imageNamed:@"btn_del"] forState:UIControlStateNormal];
        [delBtn addTarget:self action:@selector(delectThisCell:) forControlEvents:UIControlEventTouchUpInside];
        
        self.nameLab = [[UILabel alloc] init];
        self.nameLab.font = [UIFont systemFontOfSize:17];
        self.nameLab.text = @"中国平安";
        
        self.codeLab = [[UILabel alloc] init];
        self.codeLab.font = [UIFont systemFontOfSize:15];
        self.codeLab.text = @"000001";
        
        UIImageView *topImg = [[UIImageView alloc] init];
        topImg.image = [UIImage imageNamed:@"btn_zhiding_nor"];
        topImg.contentMode = UIViewContentModeScaleAspectFit;
        
        UIImageView *drapImg = [[UIImageView alloc] init];
        drapImg.image = [UIImage imageNamed:@"btn_move_nor"];
        drapImg.contentMode = UIViewContentModeScaleAspectFit;
        drapImg.userInteractionEnabled = YES;
        
        UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [drapImg addGestureRecognizer:longPress];
        
        [self addSubview:delBtn];
        [self addSubview:self.nameLab];
        [self addSubview:self.codeLab];
        [self addSubview:topImg];
        [self addSubview:drapImg];
        
        [delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).with.offset(15);
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(20);
        }];
        
        [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(10);
            make.left.equalTo(delBtn.mas_right).with.offset(15);
            make.width.mas_equalTo(kScreenWidth/3-15);
            make.height.mas_equalTo(20);
        }];
        
        [self.codeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLab.mas_bottom).with.offset(5);
            make.left.equalTo(delBtn.mas_right).with.offset(15);
            make.bottom.equalTo(self).with.offset(-10);
            make.width.mas_equalTo(kScreenWidth/3-15);
            make.height.mas_equalTo(15);
        }];
        
        [drapImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.mas_equalTo(self).with.offset(-32);
            make.width.mas_equalTo(25);
            make.height.mas_equalTo(25);
        }];
        
        CGFloat space = kScreenWidth/25*3;
        [topImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).with.offset(-80-15-space);
            make.width.mas_equalTo(25);
            make.height.mas_equalTo(25);
        }];
    }
    return self;
}

- (void)delectThisCell:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(delectThisCell:)]) {
        [self.delegate delectThisCell:sender];
    }
}

- (void)longPress:(UIGestureRecognizer*)recognizer{
    if ([self.delegate respondsToSelector:@selector(longPress:)]) {
        [self.delegate longPress:recognizer];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
