//
//  NoOrderTableViewCell.m
//  TDjuwairen
//
//  Created by 团大 on 2016/11/22.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "NoOrderTableViewCell.h"
#import "Masonry.h"

@implementation NoOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.imgView = [[UIImageView alloc] init];
        self.imgView.contentMode = UIViewContentModeScaleAspectFit;
        
        self.titLab = [[UILabel alloc] init];
        self.titLab.font = [UIFont systemFontOfSize:18];
        self.titLab.textAlignment = NSTextAlignmentCenter;
        self.titLab.textColor = TDTitleTextColor;
        
        [self addSubview:self.imgView];
        [self addSubview:self.titLab];
        
        CGFloat imgX = (kScreenHeight-108)/6;
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).with.offset(130);
            make.width.mas_equalTo(90);
            make.height.mas_equalTo(90);
        }];
        
        [self.titLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.imgView.mas_bottom).with.offset(25);
            make.bottom.equalTo(self).with.offset(-(kScreenHeight-108-imgX-90-25-40));
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


