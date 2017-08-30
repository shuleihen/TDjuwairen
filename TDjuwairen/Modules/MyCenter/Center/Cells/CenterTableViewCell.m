//
//  CenterTableViewCell.m
//  TDjuwairen
//
//  Created by zdy on 2017/8/22.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "CenterTableViewCell.h"

@implementation CenterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 15, 20, 20)];
    [self.contentView addSubview:self.iconImageView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 15, 100, 20)];
    self.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    self.titleLabel.textColor = TDTitleTextColor;
    [self.contentView addSubview:self.titleLabel];
    
    self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-191, 17, 160, 16)];
    self.detailLabel.font = [UIFont systemFontOfSize:14.0f];
    self.detailLabel.textColor = TDAssistTextColor;
    self.detailLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.detailLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
