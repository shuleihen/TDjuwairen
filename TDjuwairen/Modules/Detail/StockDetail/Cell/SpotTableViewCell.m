//
//  SpotTableViewCell.m
//  TDjuwairen
//
//  Created by zdy on 2017/1/13.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "SpotTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation SpotTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.titleLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#333333"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupSpotModel:(StockSurveyModel *)model {
    [self.spotImageView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:nil];
    self.titleLabel.text = model.title;
    self.dateTimeLabel.text = model.dateTime;
}
@end
