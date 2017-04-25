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
    self.typeImageView.image = [self imageWithSurveyType:model.surveyType];
}

// 1为实地、2为对话、5为深度、6为评论，11表示视频
- (UIImage *)imageWithSurveyType:(NSInteger)type {
    UIImage *image;
    
    switch (type) {
        case 1:
            // 调研
            image = [UIImage imageNamed:@"type_shi.png"];
            break;
        case 2:
            // 热点
            image = [UIImage imageNamed:@"tye_talk.png"];
            break;
        case 5:
            // 深度
            image = [UIImage imageNamed:@"tye_deep.png"];
            break;
        case 6:
            // 评论
            image = [UIImage imageNamed:@"type_discuss.png"];
            break;
        case 11:
            // 热点
            image = [UIImage imageNamed:@"tye_video.png"];
            break;
        default:
            break;
    }
    
    return image;
}
@end
