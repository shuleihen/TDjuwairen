//
//  AwardImfomationTableViewCell.m
//  TDjuwairen
//
//  Created by 团大 on 2016/11/24.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "AwardImfomationTableViewCell.h"

@implementation AwardImfomationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.titLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, 50)];
        
        self.field = [[UITextField alloc] initWithFrame:CGRectMake(110, 0, kScreenWidth-125, 50)];
        
        self.line = [[UILabel alloc] initWithFrame:CGRectMake(0, 49, kScreenWidth, 1)];
        self.line.layer.borderWidth = 1;
        
        [self addSubview:self.titLab];
        [self addSubview:self.field];
        [self addSubview:self.line];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
