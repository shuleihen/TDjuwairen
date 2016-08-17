//
//  MyInfomationTableViewCell.m
//  TDjuwairen
//
//  Created by 团大 on 16/7/21.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "MyInfomationTableViewCell.h"

@implementation MyInfomationTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setup];
    }
    return self;
}

- (void)setup{
    self.namelabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 80, 47)];
    self.namelabel.textColor = [UIColor darkGrayColor];
    self.namelabel.font = [UIFont systemFontOfSize:14];
    
    self.textfield = [[UITextField alloc]initWithFrame:CGRectMake(108, 0, kScreenWidth/2, 47)];
    self.textfield.backgroundColor = [UIColor whiteColor];
    self.textfield.textColor = [UIColor darkGrayColor];
    self.textfield.font = [UIFont systemFontOfSize:14];
    
    [self addSubview:self.namelabel];
    [self addSubview:self.textfield];
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
