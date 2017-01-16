//
//  GradeDetailCell.m
//  TDjuwairen
//
//  Created by zdy on 2017/1/16.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "GradeDetailCell.h"
#import "UIImageView+WebCache.h"

@implementation GradeDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.avatar.layer.cornerRadius = 20.0f;
    self.avatar.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupCommentModel:(GradeCommentModel *)model {
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:nil];
    self.userNameLabel.text = model.userName;
    self.contentLabel.text = model.content;
    self.dateTimeLabel.text = model.createTime;
    self.gradeLabel.text = [NSString stringWithFormat:@"%.0lf分",model.grade];
}

@end
