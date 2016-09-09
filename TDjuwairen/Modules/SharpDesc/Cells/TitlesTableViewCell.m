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
        self.userheadImage.layer.masksToBounds = YES;
        
        self.usernickname = [[UILabel alloc]initWithFrame:CGRectMake(15+50+10, 15, kScreenWidth/2, 20)];
        self.usernickname.textColor = [UIColor darkGrayColor];
        self.usernickname.font = [UIFont systemFontOfSize:13];
        
        self.addtime = [[UILabel alloc]initWithFrame:CGRectMake(15+50+10, 15+20, kScreenWidth/2, 20)];
        self.addtime.textColor = [UIColor lightGrayColor];
        self.addtime.font = [UIFont systemFontOfSize:12];
        
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        
        self.isAttention = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-15-80, 15, 80, 40)];
        [self.isAttention setTitle:@"关注" forState:UIControlStateNormal];
        [self.isAttention setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self.isAttention setTitle:@"已关注" forState:UIControlStateSelected];
        [self.isAttention setTitleColor:[UIColor colorWithRed:33/255.0 green:107/255.0 blue:174/255.0 alpha:1.0] forState:UIControlStateSelected];
        [self.isAttention addTarget:self action:@selector(clickAttention:) forControlEvents:UIControlEventTouchUpInside];
        self.isAttention.layer.cornerRadius = 10;
        
        self.isAttention.layer.borderWidth = 1;
        
        [self addSubview:self.userheadImage];
        [self addSubview:self.usernickname];
        [self addSubview:self.addtime];
//        [self addSubview:self.isAttention];
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)clickAttention:(UIButton *)sender{
    
    if (self.block) {
        self.block(sender);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
