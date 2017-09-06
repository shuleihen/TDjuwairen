//
//  PublishForwardTableViewCell.m
//  TDjuwairen
//
//  Created by zdy on 2017/9/6.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "PublishForwardTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation PublishForwardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupPublishModel:(AlivePublishModel *)model {
    [self.forwardImageView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:TDDefaultAppIcon];
    self.titleLabel.text = model.title;
    self.descLabel.text = model.detail;
}
@end
