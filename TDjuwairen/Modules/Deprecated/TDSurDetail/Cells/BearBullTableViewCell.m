//
//  BearBullTableViewCell.m
//  TDjuwairen
//
//  Created by 团大 on 2016/11/9.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "BearBullTableViewCell.h"

#import "Masonry.h"

@implementation BearBullTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupWithUI];
        
    }
    return self;
}

- (void)setupWithUI{
    
    self.faceMinImg = [[UIImageView alloc] init];
    self.faceMinImg.layer.cornerRadius = 15;
    self.faceMinImg.layer.masksToBounds = YES;
    
    self.nickNameLab = [[UILabel alloc] init];
    self.nickNameLab.font = [UIFont systemFontOfSize:14];
    
    self.goodnumBtn = [[UIButton alloc] init];
    
    self.commentLab = [[UILabel alloc] init];
    self.commentLab.font = [UIFont systemFontOfSize:16];
    self.commentLab.numberOfLines = 0;
    
    self.line = [[UILabel alloc] init];
    self.line.layer.borderWidth = 1;
    
    [self addSubview:self.faceMinImg];
    [self addSubview:self.nickNameLab];
    [self addSubview:self.goodnumBtn];
    [self addSubview:self.commentLab];
    [self addSubview:self.line];
    
    [self.faceMinImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(10);
        make.left.equalTo(self).with.offset(15);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    
    [self.nickNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(10);
        make.left.equalTo(self.faceMinImg).with.offset(10+30);
        make.right.equalTo(self).with.offset(-90);
        make.height.mas_equalTo(30);
    }];
    
    [self.goodnumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(10);
        make.right.equalTo(self).with.offset(-15);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
    }];
    
    [self.commentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.faceMinImg).with.offset(5+30);
        make.left.equalTo(self.faceMinImg).with.offset(10+30);
        make.right.equalTo(self).with.offset(-15);
        make.bottom.equalTo(self).with.offset(-15);
        make.height.mas_equalTo(100);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commentLab.mas_bottom).with.offset(14);
        make.left.equalTo(self).with.offset(15);
        make.right.equalTo(self).with.offset(-15);
        make.height.mas_equalTo(1);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
