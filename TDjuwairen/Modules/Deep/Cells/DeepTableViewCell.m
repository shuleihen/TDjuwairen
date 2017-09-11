//
//  SpotTableViewCell.m
//  TDjuwairen
//
//  Created by zdy on 2017/1/13.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "DeepTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "SurveyHandler.h"

@implementation DeepTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupDeepModel:(SurveyDeepModel *)model {
    [self.deepImageView sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:nil];
    self.titleLabel.text = model.surveyTitle;
    self.contentLabel.text = model.desc;
    self.dateTimeLabel.text = model.addTime;
    self.lockImageView.hidden = model.isUnlock;
    self.typeImageView.image = [SurveyHandler imageWithSurveyType:model.surveyType];
    self.descLabel.text = model.deepPayTip;
    
    if (!model.isUnlock) {
        self.descLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#FE8E3A"];
    } else {
        self.descLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#CCCCCC"];
    }
}

@end
