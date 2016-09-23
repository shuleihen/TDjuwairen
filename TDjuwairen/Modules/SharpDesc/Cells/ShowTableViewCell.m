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
        self.headImg.layer.masksToBounds = YES;
        
        self.nicknameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15+30+10, 10, kScreenWidth-70, 15)];
        self.nicknameLabel.font = [UIFont systemFontOfSize:14];
        
        self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(15+30+10, 10+15+5, kScreenWidth-70, 12)];
        self.timeLabel.font = [UIFont systemFontOfSize:11];
        
        self.commentsLabel = [[UILabel alloc]init];
        self.commentsLabel.numberOfLines = 0;
        
        self.line = [[UILabel alloc]init];
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
