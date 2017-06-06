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

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stockLabelLayoutW;

@end

@implementation AliveSearchSurveyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.stockLabel addBorder:1 borderColor:TDThemeColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


+ (CGFloat)heightWithAliveModel:(AliveSearchResultModel *)model {
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:model.survey_title attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0f], NSForegroundColorAttributeName : [UIColor hx_colorWithHexRGBAString:@"#333333"]}];
    
    NSTextAttachment *attatch = [[NSTextAttachment alloc] initWithData:nil ofType:nil];
    attatch.bounds = CGRectMake(2, -2, 17, 17);
    attatch.image = [UIImage imageNamed:@"type_shi.png"];
    NSAttributedString *video = [NSAttributedString attributedStringWithAttachment:attatch];
    [attri appendAttributedString:video];
    
    CGSize size = [attri boundingRectWithSize:CGSizeMake(kScreenWidth-24, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    
    return size.height + 52;
}


- (void)setSurveyModel:(AliveSearchResultModel *)surveyModel {
    _surveyModel = surveyModel;
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:surveyModel.survey_title attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0f], NSForegroundColorAttributeName : [UIColor hx_colorWithHexRGBAString:@"#333333"]}];
    NSTextAttachment *attatch = [[NSTextAttachment alloc] initWithData:nil ofType:nil];
    attatch.bounds = CGRectMake(2, -2, 17, 17);
    attatch.image = [self imageWithSurveyType:[surveyModel.survey_type integerValue]];
    
    NSAttributedString *surveyTitleAttriStr = [NSAttributedString attributedStringWithAttachment:attatch];
    [attri appendAttributedString:surveyTitleAttriStr];
    self.surveyTitleLabel.attributedText = attri;
    self.stockLabel.text = [NSString stringWithFormat:@"%@(%@)",surveyModel.company_name,surveyModel.company_code];
    self.dateLabel.text = surveyModel.surveyAddtime;
    self.stockLabelLayoutW.constant = [self.stockLabel.text calculateSize:CGSizeMake(CGFLOAT_MAX, 20) font:[UIFont systemFontOfSize:12.0]].width+8;
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
