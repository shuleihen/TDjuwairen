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
        self.userheadImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 50, 50)];
        self.userheadImage.layer.cornerRadius = 25;
        
        self.usernickname = [[UILabel alloc]initWithFrame:CGRectMake(15+50+10, 15, kScreenWidth/2, 20)];
        self.usernickname.textColor = [UIColor darkGrayColor];
        self.usernickname.font = [UIFont systemFontOfSize:13];
        
        self.addtime = [[UILabel alloc]initWithFrame:CGRectMake(15+50+10, 15+20, kScreenWidth/2, 20)];
        self.addtime.textColor = [UIColor lightGrayColor];
        self.addtime.font = [UIFont systemFontOfSize:12];
        
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        
        [self addSubview:self.userheadImage];
        [self addSubview:self.usernickname];
        [self addSubview:self.addtime];
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
