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
#import "UIdaynightModel.h"

@implementation SurveryStockListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // 调用公司缩略图
        _surveyImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_surveyImageView];
        
        // 上市公司名称和股票代码
        _stockNameLabel = [[UILabel alloc] init];
        _stockNameLabel.font = [UIFont systemFontOfSize:12.0f];
        _stockNameLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"999999"];
        _stockNameLabel.layer.borderColor = [UIColor hx_colorWithHexRGBAString:@"999999"].CGColor;
        _stockNameLabel.layer.borderWidth = TDPixel;
        _stockNameLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_stockNameLabel];
        
        // 当前交易价格
        _stockNowPriLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_stockNowPriLabel];
        
        
        // 调用文章标题
        _surveyTitleLabel = [[UILabel alloc] init];
        _surveyTitleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        _surveyTitleLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#333333"];
        _surveyTitleLabel.numberOfLines = 2;
        [self.contentView addSubview:_surveyTitleLabel];
        
        // 时间
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.font = [UIFont systemFontOfSize:12.0f];
        _dateLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#cccccc"];
        [self.contentView addSubview:_dateLabel];
        
        // 类别icon
        _typeImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_typeImageView];
        
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)rowHeight {
    return 118;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    
    _surveyImageView.frame = CGRectMake(15.0f, 15.0f, 100, 60);
    _typeImageView.frame = CGRectMake(w-17-12, 15, 17, 17);
    
    _dateLabel.frame = CGRectMake(127, 63, 150, 14);
}

- (void)setupSurvey:(SurveyModel *)survey {
    
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    
    NSString *stockName = [NSString stringWithFormat:@"%@(%@)",survey.companyName,[survey.companyCode stockCode]];
    CGSize stockNameSize = [stockName boundingRectWithSize:CGSizeMake(MAXFLOAT, 14) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0f]} context:nil].size;
    _stockNameLabel.text = stockName;
    _stockNameLabel.frame = CGRectMake(15, 86, stockNameSize.width+4, 20);
    
    _stockNowPriLabel.frame = CGRectMake(CGRectGetMaxX(_stockNameLabel.frame)+12, 86, w-CGRectGetMaxX(_stockNameLabel.frame)-24, 20);
    
    _surveyTitleLabel.text = survey.surveyTitle;
    CGSize titleSize = [_surveyTitleLabel sizeThatFits:CGSizeMake(w-127-36, MAXFLOAT)];
    _surveyTitleLabel.frame = CGRectMake(127, 14, w-127-36, titleSize.height);
    
    self.dateLabel.text = survey.addTime;
    
    [_surveyImageView sd_setImageWithURL:[NSURL URLWithString:survey.surveyCover]];
    
    _typeImageView.image = [self imageWithSurveyType:survey.surveyType];
}

- (void)setupStock:(StockInfo *)stock {
    
    if (!stock.enabled) {
        // 没有值 退市，停盘,开盘前半小时
        NSString *string = [NSString stringWithFormat:@"--"];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:string];
        [attr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f]} range:NSMakeRange(0, string.length)];
        
        _stockNowPriLabel.attributedText = attr;
    } else {
        float value = [stock priValue];            //跌涨额
        float valueB = [stock priPercentValue];     //跌涨百分比
        NSString *nowPriString = [NSString stringWithFormat:@"%.2lf",stock.nowPriValue];
        
        NSString *string = [NSString stringWithFormat:@"%@  %+.2lf  %+.2lf%%",nowPriString,value,valueB*100];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:string];
        
        NSString *fo = [NSString getiPHoneDeviceType];
        UIFont *font1 ;
        UIFont *font2 ;
        if ([fo isEqualToString:@"1"]) {
            font1 = [UIFont systemFontOfSize:13];
            font2 = [UIFont systemFontOfSize:12];
        }
        else
        {
            font1 = [UIFont systemFontOfSize:12];
            font2 = [UIFont systemFontOfSize:11];
        }
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
            // 热点
            image = [UIImage imageNamed:@"type_video.png"];
            break;
        default:
            break;
    }
    
    return image;
}
@end
