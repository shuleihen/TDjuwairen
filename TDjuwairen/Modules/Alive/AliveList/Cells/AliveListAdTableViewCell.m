//
//  AliveListAdTableViewCell.m
//  TDjuwairen
//
//  Created by zdy on 2017/7/19.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveListAdTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation AliveListAdTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupAliveModel:(AliveListModel *)model {
    self.titleLabel.text = model.aliveTitle;
    [self.adImageView sd_setImageWithURL:[NSURL URLWithString:model.aliveImgs.firstObject] placeholderImage:nil];
}


- (IBAction)closePressed:(id)sender {
}
@end
