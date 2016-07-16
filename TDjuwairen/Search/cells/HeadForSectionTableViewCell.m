//
//  HeadForSectionTableViewCell.m
//  TDjuwairen
//
//  Created by 团大 on 16/6/1.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "HeadForSectionTableViewCell.h"

@implementation HeadForSectionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.imgview = [[UIImageView alloc]initWithFrame:CGRectMake(15, 8, 25, 25)];
        self.headlabel = [[UILabel alloc]initWithFrame:CGRectMake(40+8, 8, kScreenWidth/2, 28)];
        
        [self addSubview:self.imgview];
        [self addSubview:self.headlabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
