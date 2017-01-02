//
//  SetUpTableViewCell.m
//  TDjuwairen
//
//  Created by 团大 on 16/7/21.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "SetUpTableViewCell.h"
#import "HexColors.h"

@implementation SetUpTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, (self.frame.size.height-17)/2, 17, 17)];
        self.title = [[UILabel alloc]initWithFrame:CGRectMake(40, (self.frame.size.height-20)/2, self.frame.size.width/3, 20)];
        self.title.textColor = [HXColor hx_colorWithHexRGBAString:@"#646464"];
        self.title.font = [UIFont systemFontOfSize:16.0f];
        self.numberLabel.textColor = [HXColor hx_colorWithHexRGBAString:@"#646464"];
        
        self.numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-90, (self.frame.size.height-17)/2, 50, 17)];
        self.numberLabel.textAlignment = NSTextAlignmentRight;
        
        [self.contentView addSubview:self.imgView];
        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.numberLabel];
        
        self.contentView.dk_backgroundColorPicker = DKColorPickerWithKey(CONTENTBG);
        self.title.dk_textColorPicker = DKColorPickerWithKey(TEXT);
        self.dk_backgroundColorPicker = DKColorPickerWithKey(CONTENTBG);
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
