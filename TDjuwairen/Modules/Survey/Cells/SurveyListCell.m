//
//  SurveyListCell.m
//  TDjuwairen
//
//  Created by zdy on 16/10/11.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "SurveyListCell.h"
#import "UIImageView+WebCache.h"

@implementation SurveyListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.userAvatar.layer.cornerRadius = 25.0/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupSurveyListModel:(SurveyListModel *)model {
    [self.userAvatar sd_setImageWithURL:[NSURL URLWithString:model.user_facemin]];
    self.nameLabel.text = [NSString stringWithFormat:@"%@ · %@",model.user_nickname,model.sharp_wtime];
    
    self.titleLabel.text = model.sharp_title;
    self.detailLabel.text = model.sharp_desc;
    [self.thumbImageView sd_setImageWithURL:[NSURL URLWithString:model.sharp_imgurl]];
}
@end
