//
//  ShowTableViewCell.m
//  TDjuwairen
//
//  ShowTableViewCell.m
//  TDjuwairen
//
//  Created by 团大 on 16/6/2.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "ShowTableViewCell.h"

@implementation ShowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.headImg = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 30, 30)];
        self.headImg.layer.cornerRadius = 15;
        
        self.nicknameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15+30+10, 10, kScreenWidth/3, 15)];
        self.nicknameLabel.font = [UIFont systemFontOfSize:14];
        
        self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(15+30+10, 10+15+5, kScreenWidth/3, 12)];
        self.timeLabel.font = [UIFont systemFontOfSize:11];
        
        self.commentsLabel = [[UILabel alloc]init];
        self.commentsLabel.numberOfLines = 0;
        
        self.line = [[UILabel alloc]init];
        self.line.layer.borderColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0].CGColor;
        self.line.layer.borderWidth = 1;
        
        [self addSubview:self.headImg];
        [self addSubview:self.nicknameLabel];
        [self addSubview:self.timeLabel];
        [self addSubview:self.commentsLabel];
        [self addSubview:self.line];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
