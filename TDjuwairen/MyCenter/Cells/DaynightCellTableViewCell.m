//
//  DaynightCellTableViewCell.m
//  TDjuwairen
//
//  Created by 团大 on 16/8/15.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "DaynightCellTableViewCell.h"
#import "HexColors.h"

@implementation DaynightCellTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, (self.frame.size.height-17)/2, 17, 17)];
        self.title = [[UILabel alloc]initWithFrame:CGRectMake(40, (self.frame.size.height-20)/2, self.frame.size.width/3, 20)];
        self.title.textColor = [HXColor hx_colorWithHexRGBAString:@"#646464"];
        self.title.font = [UIFont systemFontOfSize:16.0f];
        self.mySwitch = [[UISwitch alloc]initWithFrame:CGRectMake(kScreenWidth-60, 8, 20, 20)];
        [self.mySwitch addTarget:self action:@selector(updateSwitchAtIndexPath:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.imgView];
        [self addSubview:self.title];
        self.accessoryView = self.mySwitch;
    }
    return self;
}

- (void)updateSwitchAtIndexPath:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(updateSwitchAtIndexPath:)]) {
        [self.delegate updateSwitchAtIndexPath:sender];
    }
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
