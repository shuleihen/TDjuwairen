//
//  ViewpointHeaderTableViewCell.m
//  TDjuwairen
//
//  Created by zdy on 2017/6/11.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "ViewpointHeaderTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation ViewpointHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupViewModel:(ViewModel *)model {
    
    [self.authorAvatar sd_setImageWithURL:[NSURL URLWithString:model.userinfo_facesmall] placeholderImage:TDDefaultUserAvatar];
    
    self.authorNameLabel.text = model.view_author;
    
    self.viewpointTitleLabel.text = model.view_title;
    
    self.dateLabel.text = model.view_addtime;
    
    
}
@end
