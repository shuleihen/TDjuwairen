//
//  AliveSearchSurveyCell.m
//  TDjuwairen
//
//  Created by ZYP-MAC on 17/6/1.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveSearchSurveyCell.h"
#import "AliveSearchResultModel.h"
#import "UIView+Border.h"
#import "NSString+Ext.h"

@interface AliveSearchSurveyCell ()
@property (weak, nonatomic) IBOutlet UILabel *surveyTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *stockLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (nonatomic, strong) UIImageView *typeImageView;

@end

@implementation AliveSearchSurveyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.stockLabel addBorder:1 borderColor:TDThemeColor];
    _typeImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_typeImageView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setSurveyModel:(AliveSearchResultModel *)surveyModel {
    _surveyModel = surveyModel;
    self.surveyTitleLabel.text = surveyModel.survey_title;
    self.stockLabel.text = [NSString stringWithFormat:@"%@(%@)",surveyModel.company_name,surveyModel.company_code];
    self.stockLabel.frame = CGRectMake(12, CGRectGetMidY(self.stockLabel.frame), CGRectGetWidth(self.stockLabel.frame)+8, CGRectGetHeight(self.stockLabel.frame)+4);
    self.dateLabel.text = surveyModel.surveyAddtime;
    _typeImageView.image = [self imageWithSurveyType:[surveyModel.survey_type integerValue]];
}

- (void)layoutSubviews {
    CGFloat cellW = [self.surveyTitleLabel.text calculateSize:CGSizeMake(CGFLOAT_MAX, 17) font:[UIFont systemFontOfSize:17.0f]].width;
    CGFloat cellH = [self.surveyTitleLabel.text calculateSize:CGSizeMake(kScreenWidth-24, CGFLOAT_MAX) font:[UIFont systemFontOfSize:17.0f]].height;
    NSInteger row = cellW/(kScreenWidth-24);
    CGFloat orginX = cellW-row*(kScreenWidth-24);
    if (orginX+17+12>(kScreenWidth-24)) {
       _typeImageView.frame = CGRectMake(12, 12+cellH+8, 17, 17);
    }else {
        _typeImageView.frame = CGRectMake(orginX+24, 12+cellH-18, 17, 17);
    }
    
}


+ (instancetype)loadAliveSearchSurveyCellWithTableView:(UITableView *)tableView {

    AliveSearchSurveyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AliveSearchSurveyCell"];
    if (cell == nil)
    {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"AliveSearchSurveyCell" owner:self options:nil] lastObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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
            image = [UIImage imageNamed:@"type_talk.png"];
            break;
        case 5:
            // 深度
            image = [UIImage imageNamed:@"type_deep.png"];
            break;
        case 6:
            // 评论
            image = [UIImage imageNamed:@"type_discuss.png"];
            break;
        case 11:
            // 视频
            image = [UIImage imageNamed:@"type_video.png"];
            break;
        default:
            break;
    }
    
    return image;
}


@end
