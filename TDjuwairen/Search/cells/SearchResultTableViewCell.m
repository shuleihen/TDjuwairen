//
//  SearchResultTableViewCell.m
//  TDjuwairen
//
//  Created by 团大 on 16/6/1.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "SearchResultTableViewCell.h"

@implementation SearchResultTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.titleLabel = [[UILabel alloc]init];
        [self.titleLabel setNumberOfLines:0];
        [self addSubview:self.titleLabel];
        
        self.timeLabel = [[UILabel alloc]init];
        [self.timeLabel setNumberOfLines:0];
        [self addSubview:self.timeLabel];
        
        self.line = [[UILabel alloc]init];
        self.line.layer.borderColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0].CGColor;
        self.line.layer.borderWidth = 0.5;
        [self addSubview:self.line];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
