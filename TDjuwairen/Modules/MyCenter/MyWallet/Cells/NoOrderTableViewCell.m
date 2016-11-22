//
//  NoOrderTableViewCell.m
//  TDjuwairen
//
//  Created by 团大 on 2016/11/22.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "NoOrderTableViewCell.h"
#import "Masonry.h"
#import "UIdaynightModel.h"

@implementation NoOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //
        UIdaynightModel *daynightModel = [UIdaynightModel sharedInstance];
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        
        UILabel *lab = [[UILabel alloc] init];
        lab.font = [UIFont systemFontOfSize:18];
        lab.text = @"暂时没有订单~";
        lab.textColor = daynightModel.titleColor;
        
        [self addSubview:imgView];
        [self addSubview:lab];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(90);
            make.centerY.equalTo(self);
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(50);
        }];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imgView).with.offset(25);
            make.centerY.equalTo(self);
            make.bottom.equalTo(self).with.offset(108-90-50-25-40);
            make.width.mas_equalTo(kScreenWidth);
            make.height.mas_equalTo(40);
        }];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
