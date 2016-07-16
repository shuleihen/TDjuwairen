//
//  TitlesTableViewCell.m
//  TDjuwairen
//
//  Created by 团大 on 16/5/23.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "TitlesTableViewCell.h"

@implementation TitlesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - 创建button
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 25, kScreenWidth-30, 50)];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.font = [UIFont systemFontOfSize:17];
        self.userheadImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 80, 25, 25)];
        self.usernickname = [[UILabel alloc]initWithFrame:CGRectMake(50, 82.5, kScreenWidth/2, 20)];
        self.usernickname.font = [UIFont systemFontOfSize:12];
        self.userheadImage.layer.cornerRadius = 25/2;
        self.usernickname.textColor = [UIColor lightGrayColor];
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 115, kScreenWidth, 1)];
        line.layer.borderWidth = 1;//边框宽度
        line.layer.borderColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0].CGColor;
        [self addSubview:self.titleLabel];
        [self addSubview:self.usernickname];
        [self addSubview:self.userheadImage];
        [self addSubview:line];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
