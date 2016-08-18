//
//  ViewPointTableViewCell.m
//  TDjuwairen
//
//  Created by 团大 on 16/7/25.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "ViewPointTableViewCell.h"

@implementation ViewPointTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.headImgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 25, 25)];
        self.headImgView.layer.cornerRadius = 25/2;
        self.headImgView.layer.masksToBounds = YES;
        
        self.nicknameLabel = [[UILabel alloc]initWithFrame:CGRectMake(48, 15, kScreenWidth-55, 20)];
        self.nicknameLabel.textColor = [UIColor darkGrayColor];
        self.nicknameLabel.font = [UIFont systemFontOfSize:12];
        
        self.nature = [[UILabel alloc]init];
        self.nature.textColor = [UIColor darkGrayColor];
        
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        
        self.lineLabel = [[UILabel alloc]init];
        self.lineLabel.layer.borderColor = [UIColor colorWithRed:240/255.0 green:242/255.0 blue:245/255.0 alpha:1.0].CGColor;
        self.lineLabel.layer.borderWidth = 1;
        [self addSubview:self.lineLabel];
        
        [self addSubview:self.headImgView];
        [self addSubview:self.nicknameLabel];
        [self addSubview:self.nature];
        [self addSubview:self.titleLabel];
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
