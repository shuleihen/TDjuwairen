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
#import "SurveyHandler.h"
#import "SurveyTypeDefine.h"

@interface AliveSearchSurveyCell ()
@property (weak, nonatomic) IBOutlet UILabel *surveyTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *stockLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stockLabelLayoutW;

@end

@implementation AliveSearchSurveyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
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
    if (surveyModel.searchTextStr.length > 0) {
        NSMutableArray *arrM = [self getRangeStr:surveyModel.survey_title findText:surveyModel.searchTextStr];
        for (NSNumber *num in arrM) {
            NSRange rang = NSMakeRange([num integerValue], surveyModel.searchTextStr.length);
            [attri addAttribute:NSForegroundColorAttributeName value:[UIColor hx_colorWithHexRGBAString:@"#FF6C00"] range:rang];
        }
        
    }
    NSTextAttachment *attatch = [[NSTextAttachment alloc] initWithData:nil ofType:nil];
    attatch.bounds = CGRectMake(2, -2, 17, 17);
    attatch.image = [SurveyHandler imageWithSurveyType:surveyModel.survey_type];
    
    NSAttributedString *surveyTitleAttriStr = [NSAttributedString attributedStringWithAttachment:attatch];
    [attri appendAttributedString:surveyTitleAttriStr];
    self.surveyTitleLabel.attributedText = attri;
    
    self.dateLabel.text = surveyModel.surveyAddtime;
    if (surveyModel.survey_type == kSurveyTypeShengdu) {
        [self.stockLabel addBorder:1 borderColor:[UIColor clearColor]];
        self.stockLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#FE8E3A"];
        self.stockLabel.textAlignment = NSTextAlignmentLeft;
        self.stockLabel.text = surveyModel.deepPayTip;
        CGSize stockSize = [surveyModel.deepPayTip boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.0f]} context:nil].size;
        self.stockLabelLayoutW.constant = stockSize.width+6;
    } else {
        [self.stockLabel addBorder:1 borderColor:TDThemeColor];
        self.stockLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#3371E2"];
        self.stockLabel.textAlignment = NSTextAlignmentCenter;
        self.stockLabel.text = [NSString stringWithFormat:@"%@(%@)",surveyModel.company_name,surveyModel.company_code];
        self.stockLabelLayoutW.constant = [self.stockLabel.text calculateSize:CGSizeMake(CGFLOAT_MAX, 20) font:[UIFont systemFontOfSize:12.0]].width+8;
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

- (NSMutableArray *)getRangeStr:(NSString *)text findText:(NSString *)findText
{
    
    NSMutableArray *arrayRanges = [NSMutableArray arrayWithCapacity:3];
    
    if (findText == nil && [findText isEqualToString:@""])
    {
        
        return nil;
        
    }
    
    NSRange rang = [text rangeOfString:findText]; //获取第一次出现的range
    
    if (rang.location != NSNotFound && rang.length != 0)
    {
        
        [arrayRanges addObject:[NSNumber numberWithInteger:rang.location]];//将第一次的加入到数组中
        
        NSRange rang1 = {0,0};
        
        NSInteger location = 0;
        
        NSInteger length = 0;
        
        for (int i = 0;; i++)
        {
            
            if (0 == i)
            {
                
                //去掉这个abc字符串
                location = rang.location + rang.length;
                
                length = text.length - rang.location - rang.length;
                
                rang1 = NSMakeRange(location, length);
                
            }
            else
            {
                
                location = rang1.location + rang1.length;
                
                length = text.length - rang1.location - rang1.length;
                
                rang1 = NSMakeRange(location, length);
                
            }
            
            //在一个range范围内查找另一个字符串的range
            
            rang1 = [text rangeOfString:findText options:NSCaseInsensitiveSearch range:rang1];
            
            if (rang1.location == NSNotFound && rang1.length == 0)
            {
                
                break;
                
            }
            else//添加符合条件的location进数组
                
                [arrayRanges addObject:[NSNumber numberWithInteger:rang1.location]];
            
        }
        
        return arrayRanges;
        
    }
    
    return nil;
    
}


@end
