//
//  NewTableViewCell.m
//  TDjuwairen
//
//  Created by 团大 on 16/5/25.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "NewTableViewCell.h"

@implementation NewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.userHead = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 25, 25)];
        self.userHead.layer.cornerRadius = 25/2;
        self.userHead.layer.masksToBounds = YES;
        [self addSubview:self.userHead];
        
        self.nickname = [[UILabel alloc]initWithFrame:CGRectMake(48, 15, kScreenWidth-48-8, 25)];
        self.nickname.textColor = [UIColor lightGrayColor];
        self.nickname.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.nickname];
        
        self.titleLabel = [[UILabel alloc]init];
        [self addSubview:self.titleLabel];
        
        self.descLabel = [[UILabel alloc]init];
        [self addSubview:self.descLabel];
        
        self.titleimg = [[UIImageView alloc]init];
        [self addSubview:self.titleimg];
        // Initialization code
        
        self.lineLabel = [[UILabel alloc]init];
        self.lineLabel.layer.borderColor = [UIColor colorWithRed:240/255.0 green:242/255.0 blue:245/255.0 alpha:1.0].CGColor;
        self.lineLabel.layer.borderWidth = 1;
        [self addSubview:self.lineLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
