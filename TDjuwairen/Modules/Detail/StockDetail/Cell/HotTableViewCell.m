//
//  HotTableViewCell.m
//  TDjuwairen
//
//  Created by zdy on 2017/1/18.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "HotTableViewCell.h"

@implementation HotTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupSpotModel:(StockHotModel *)model {
    self.titleLabel.text = model.title;
    self.dateTimeLabel.text = model.dateTime;
    self.sourceLabel.text = model.source;
}
@end
