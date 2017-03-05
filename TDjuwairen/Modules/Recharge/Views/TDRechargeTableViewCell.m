//
//  TDRechargeTableViewCell.m
//  TDjuwairen
//
//  Created by zdy on 2017/3/5.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "TDRechargeTableViewCell.h"

@implementation TDRechargeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    self.selectedImageView.highlighted = selected;
}
@end
