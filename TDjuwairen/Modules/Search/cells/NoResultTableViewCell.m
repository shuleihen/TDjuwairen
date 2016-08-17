//
//  NoResultTableViewCell.m
//  TDjuwairen
//
//  Created by 团大 on 16/8/17.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "NoResultTableViewCell.h"
#import "NSString+Ext.h"

@implementation NoResultTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //
        UIImageView *imgview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 60, 40)];
        imgview.image = [UIImage imageNamed:@"bg_big"];
        imgview.contentMode = UIViewContentModeScaleToFill;
        imgview.center = CGPointMake(kScreenWidth/2, 30);
        
        self.label = [[UILabel alloc]init];
        
        self.submit = [[UIButton alloc]init];
        [self.submit setTitle:@"提交" forState:UIControlStateNormal];
        self.submit.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.submit setBackgroundImage:[UIImage imageNamed:@"btn_normal"] forState:UIControlStateNormal];
        [self.submit addTarget:self action:@selector(clickSubmit:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:imgview];
        [self addSubview:self.label];
        [self addSubview:self.submit];

    }
    return self;
}

- (void)clickSubmit:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(clickSubmit:)]) {
        [self.delegate clickSubmit:sender];
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
