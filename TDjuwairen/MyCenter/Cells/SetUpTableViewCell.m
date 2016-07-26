//
//  SetUpTableViewCell.m
//  TDjuwairen
//
//  Created by 团大 on 16/7/21.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "SetUpTableViewCell.h"

@implementation SetUpTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(20, (self.frame.size.height-17)/2, 17, 17)];
        self.title = [[UILabel alloc]initWithFrame:CGRectMake(45, (self.frame.size.height-20)/2, self.frame.size.width/3, 20)];
        self.title.textColor = [UIColor darkGrayColor];
        self.numberLabel.textColor = [UIColor darkGrayColor];
        
        self.numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-90, (self.frame.size.height-17)/2, 50, 17)];
        self.numberLabel.textAlignment = NSTextAlignmentRight;
        
        [self addSubview:self.imgView];
        [self addSubview:self.title];
        [self addSubview:self.numberLabel];
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
