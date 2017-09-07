//
//  SurveyListTableViewCell.m
//  TDjuwairen
//
//  Created by zdy on 2017/6/14.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "SurveyListTableViewCell.h"
#import "NSString+Util.h"
#import "UIImageView+WebCache.h"

@implementation SurveyListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // 调用公司缩略图
        _surveyImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_surveyImageView];
        
        // 上市公司名称和股票代码
        _stockNameLabel = [[UILabel alloc] init];
        _stockNameLabel.font = [UIFont systemFontOfSize:17.0f weight:UIFontWeightMedium];
        _stockNameLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"333333"];
        _stockNameLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_stockNameLabel];
        
        UITapGestureRecognizer *stockNameTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stockNamePressed:)];
        _stockNameLabel.userInteractionEnabled = YES;
        [_stockNameLabel addGestureRecognizer:stockNameTap];
        
        // 当前交易价格
        _stockNowPriLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_stockNowPriLabel];
        
        
        // 调用文章标题
        _surveyTitleLabel = [[UILabel alloc] init];
        _surveyTitleLabel.font = [UIFont systemFontOfSize:12.0f];
        _surveyTitleLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#333333"];
        [self.contentView addSubview:_surveyTitleLabel];
        
        /*
        UITapGestureRecognizer *titleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titlePressed:)];
        _surveyTitleLabel.userInteractionEnabled = YES;
        [_surveyTitleLabel addGestureRecognizer:titleTap];
        */
        
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    
    _surveyImageView.frame = CGRectMake(15.0f, 15.0f, 100, 60);
    _stockNameLabel.frame = CGRectMake(127, 14, w-130, 17);
    _stockNowPriLabel.frame = CGRectMake(127, 42, w-130, 30);
    _surveyTitleLabel.frame = CGRectMake(15, 90, w-30, 17);
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

- (void)setupSurvey:(SurveyListModel *)survey {
    self.model = survey;
    
    [_surveyImageView sd_setImageWithURL:[NSURL URLWithString:survey.surveyCover]];
    
    NSString *stockName = [NSString stringWithFormat:@"%@(%@)",survey.companyName,[survey.companyCode stockCode]];
    _stockNameLabel.text = stockName;
    
    NSString *typeString = [self articleType:survey.surveyTitleType];
    UIColor *color = [self articleColorWithType:survey.surveyTitleType];
    
    if (typeString.length) {
        NSAttributedString *attri1 = [[NSAttributedString alloc] initWithString:[typeString stringByAppendingString:@" "] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName: color}];
        
        NSAttributedString *attri2 = [[NSAttributedString alloc] initWithString:survey.surveyTitle attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName: TDTitleTextColor}];
        
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] init];
        [attri appendAttributedString:attri1];
        [attri appendAttributedString:attri2];
        _surveyTitleLabel.attributedText = attri;
    } else {
        NSAttributedString *attri2 = [[NSAttributedString alloc] initWithString:survey.surveyTitle attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName: TDTitleTextColor}];
        
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] init];
        [attri appendAttributedString:attri2];
        _surveyTitleLabel.attributedText = attri;
    }
    
}

- (void)setupStock:(StockInfo *)stock {
    
    if (!stock.enabled) {
        // 没有值 退市，停盘,开盘前半小时
        NSString *string = [NSString stringWithFormat:@"--"];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:string];
        [attr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]} range:NSMakeRange(0, string.length)];
        
        _stockNowPriLabel.attributedText = attr;
    } else {
        float value = [stock priValue];            //跌涨额
        float valueB = [stock priPercentValue];     //跌涨百分比
        NSString *nowPriString = [NSString stringWithFormat:@"%.2lf",stock.nowPriValue];
        
        NSString *string = [NSString stringWithFormat:@"%@  %+.2lf  %+.2lf%%",nowPriString,value,valueB*100];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:string];
        
        UIFont *font1 = [UIFont systemFontOfSize:25];
        UIFont *font2 = [UIFont systemFontOfSize:13];

        [attr setAttributes:@{NSFontAttributeName:font1} range:NSMakeRange(0, nowPriString.length)];
        [attr setAttributes:@{NSFontAttributeName:font2} range:NSMakeRange(nowPriString.length,string.length-nowPriString.length)];
        
        if (value >= 0.00) {
            _stockNowPriLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#e74922"];
        } else {
            _stockNowPriLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#13C869"];
        }
        _stockNowPriLabel.attributedText = attr;
    }
}

// 自选列表标题类型：1表示调研；2表示热点，3表示暂无,4表示公告
- (NSString *)articleType:(NSInteger)type {
    
    NSString *str = @"";
    switch (type) {
        case 1:
            str = @"调研";
            break;
        case 2:
            str = @"热点";
            break;
        case 3:
            str = @"暂无";
            break;
        case 4:
            str = @"公告";
            break;
        default:
            break;
    }
    
    return str;
}

- (UIColor *)articleColorWithType:(NSInteger)type {
    
    UIColor *color = TDAssistTextColor;
    switch (type) {
        case 1:
            color = [UIColor hx_colorWithHexRGBAString:@"#386AC6"];
            break;
        case 2:
            color = [UIColor hx_colorWithHexRGBAString:@"#DE5030"];
            break;
        case 3:
            color = TDAssistTextColor;
            break;
        case 4:
            color = [UIColor hx_colorWithHexRGBAString:@"#5E44C1"];
            break;
        default:
            break;
    }
    
    return color;
}
@end
