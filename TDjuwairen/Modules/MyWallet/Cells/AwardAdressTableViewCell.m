//
//  AwardAdressTableViewCell.m
//  TDjuwairen
//
//  Created by 团大 on 2016/11/24.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "AwardAdressTableViewCell.h"

@implementation AwardAdressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.titLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, 50)];
        
        self.textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 50, kScreenWidth-30, 125)];
        self.textView.font = [UIFont systemFontOfSize:16];
        
        self.line = [[UILabel alloc] initWithFrame:CGRectMake(0, 199, kScreenWidth, 1)];
        self.line.layer.borderWidth = 1;
        
        [self addSubview:self.titLab];
        [self addSubview:self.textView];
        [self addSubview:self.line];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
