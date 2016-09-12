//
//  MyAttentionTableViewCell.m
//  TDjuwairen
//
//  Created by 团大 on 16/8/27.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "MyAttentionTableViewCell.h"

@implementation MyAttentionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.headImg = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 40, 40)];
        self.headImg.layer.cornerRadius = 20;
        self.headImg.layer.masksToBounds = YES;
        
        self.nicknameLab = [[UILabel alloc]initWithFrame:CGRectMake(15+40+10, 10, kScreenWidth-60, 40)];
        self.nicknameLab.font = [UIFont systemFontOfSize:16];
        
        self.line = [[UILabel alloc]initWithFrame:CGRectMake(15, 59, kScreenWidth-15, 1)];
        self.line.layer.borderWidth = 1;
        
        [self addSubview:self.headImg];
        [self addSubview:self.nicknameLab];
        [self addSubview:self.line];
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
