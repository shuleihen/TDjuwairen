//
//  ViewSpecialTableViewCell.m
//  TDjuwairen
//
//  Created by 团大 on 16/7/26.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "ViewSpecialTableViewCell.h"

@implementation ViewSpecialTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor colorWithRed:243/255.0 green:244/255.0 blue:246/255.0 alpha:1.0];
        
        self.backWhiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth/2+40)];
        self.backWhiteView.backgroundColor = [UIColor whiteColor];
        
        self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth/2)];
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, kScreenWidth/2, kScreenWidth-40, 40)];
        self.titleLabel.backgroundColor = [UIColor whiteColor];
        
        self.pageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 20)];
        self.pageLabel.backgroundColor = [UIColor colorWithRed:33/255.0 green:107/255.0 blue:174/255.0 alpha:1.0];
        self.pageLabel.textColor = [UIColor whiteColor];
        self.pageLabel.textAlignment = NSTextAlignmentCenter;
        self.pageLabel.font = [UIFont systemFontOfSize:14];
        
        [self addSubview:self.backWhiteView];
        [self addSubview:self.imgView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.pageLabel];
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
