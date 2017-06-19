//
//  SurveryStockListCell.m
//  TDjuwairen
//
//  Created by zdy on 2016/11/22.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "SurveryStockListCell.h"
#import "HexColors.h"
#import "UIImageView+WebCache.h"
#import "NSString+GetDevice.h"
#import "NSString+Util.h"
#import "SurveyHandler.h"

@implementation SurveryStockListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // 调用公司缩略图
        _surveyImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_surveyImageView];
        
        // 上市公司名称和股票代码
        _stockNameLabel = [[UILabel alloc] init];
        _stockNameLabel.font = [UIFont systemFontOfSize:12.0f];
        _stockNameLabel.textColor = TDThemeColor;
        _stockNameLabel.layer.borderColor = TDAssistTextColor.CGColor;
        _stockNameLabel.layer.borderWidth = TDPixel;
        _stockNameLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_stockNameLabel];
        
        UITapGestureRecognizer *stockNameTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stockNamePressed:)];
        _stockNameLabel.userInteractionEnabled = YES;
        [_stockNameLabel addGestureRecognizer:stockNameTap];
        
        
        // 调用文章标题
        _surveyTitleLabel = [[UILabel alloc] init];
        _surveyTitleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        _surveyTitleLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#333333"];
        _surveyTitleLabel.numberOfLines = 2;
        _surveyTitleLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_surveyTitleLabel];
        
        UITapGestureRecognizer *titleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titlePressed:)];
        _surveyTitleLabel.userInteractionEnabled = YES;
        [_surveyTitleLabel addGestureRecognizer:titleTap];
        
        // 时间
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.font = [UIFont systemFontOfSize:12.0f];
        _dateLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#cccccc"];
        _dateLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_dateLabel];
        
        // 类别icon
        _typeImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_typeImageView];
        
        _lockImageView = [[UIImageView alloc] init];
        _lockImageView.image = [UIImage imageNamed:@"ico_chains"];
        [self.contentView addSubview:_lockImageView];
        
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)stockNamePressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(surveyStockListStockNamePressedWithSurveyListModel:)]) {
        [self.delegate surveyStockListStockNamePressedWithSurveyListModel:self.model];
    }
}

- (void)titlePressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(surveyStockListTitlePressedWithSurveyListModel:)]) {
        [self.delegate surveyStockListTitlePressedWithSurveyListModel:self.model];
    }
}

+ (CGFloat)rowHeight {
    return 118;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    
    _surveyImageView.frame = CGRectMake(15.0f, 15.0f, 100, 60);
    _lockImageView.frame = CGRectMake(115-9, 75-9, 17, 17);
    _typeImageView.frame = CGRectMake(w-17-12, 15, 17, 17);
    
    _dateLabel.frame = CGRectMake(w-165, 55, 150, 20);
}

- (void)setupSurvey:(SurveyListModel *)survey {
    self.model = survey;
    
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    
    NSString *stockName = [NSString stringWithFormat:@"%@(%@)",survey.companyName,[survey.companyCode stockCode]];
    CGSize stockNameSize = [stockName boundingRectWithSize:CGSizeMake(MAXFLOAT, 14) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0f]} context:nil].size;
    _stockNameLabel.text = stockName;
    _stockNameLabel.frame = CGRectMake(127, 55, stockNameSize.width+6, 20);
    
    _surveyTitleLabel.text = survey.surveyTitle;
    CGSize titleSize = [_surveyTitleLabel sizeThatFits:CGSizeMake(w-127-36, MAXFLOAT)];
    _surveyTitleLabel.frame = CGRectMake(127, 14, w-127-36, titleSize.height);
    
    self.dateLabel.text = survey.addTime;
    
    [_surveyImageView sd_setImageWithURL:[NSURL URLWithString:survey.surveyCover]];
    
    _typeImageView.image = [SurveyHandler imageWithSurveyType:survey.surveyType];
    
    _lockImageView.hidden = survey.isUnlocked;
}

@end
