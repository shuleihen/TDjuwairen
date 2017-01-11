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
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12.0, 14, kScreenWidth-24, 18)];
        _titleLabel.font = [UIFont systemFontOfSize:15.0f];
        _titleLabel.dk_textColorPicker = DKColorPickerWithKey(CELLTITLE);
        [self.contentView addSubview:_titleLabel];
        
        self.contentView.dk_backgroundColorPicker = DKColorPickerWithKey(CONTENTBG);
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
