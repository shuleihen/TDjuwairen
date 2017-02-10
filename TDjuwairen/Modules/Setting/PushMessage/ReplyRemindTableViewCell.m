//
//  ReplyRemindTableViewCell.m
//  TDjuwairen
//
//  Created by 团大 on 16/9/23.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "ReplyRemindTableViewCell.h"

@implementation ReplyRemindTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.titleLab = [[UILabel alloc]init];
        self.titleLab.font = [UIFont systemFontOfSize:16];
        
        self.timeLab = [[UILabel alloc]init];
        self.timeLab.font = [UIFont systemFontOfSize:14];
        
        self.line = [[UILabel alloc]init];
        
        [self addSubview:self.titleLab];
        [self addSubview:self.timeLab];
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
