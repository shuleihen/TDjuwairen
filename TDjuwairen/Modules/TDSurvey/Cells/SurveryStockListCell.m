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

@implementation SurveryStockListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 调用公司缩略图
        _surveyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 60)];
        [self.contentView addSubview:_surveyImageView];
        
        // 上市公司名称和股票代码
        _stockNameLabel = [[UILabel alloc] init];
        _stockNameLabel.font = [UIFont systemFontOfSize:18.0f];
        _stockNameLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#222222"];
        [self.contentView addSubview:_stockNameLabel];
        
        // 当前交易价格
        _stockNowPriLabel = [[UILabel alloc] init];
        _stockNowPriLabel.font = [UIFont systemFontOfSize:25.0f];
        [self.contentView addSubview:_stockNowPriLabel];
//        _stockNowPriLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#1fcc67"];
        
        // 当前涨幅值和百分百
        _stockDetailLabel = [[UILabel alloc] init];
        _stockDetailLabel.font = [UIFont systemFontOfSize:15.0f];
        [self.contentView addSubview:_stockDetailLabel];
        
        // 调用文章标题
        _surveyTitleLabel = [[UILabel alloc] init];
        _surveyTitleLabel.font = [UIFont systemFontOfSize:15.0f];
        [self.contentView addSubview:_surveyTitleLabel];
        
        // 分割线
        UIImage *slipImage = [UIImage imageNamed:@"slipLine"];
        UIImageView *slipImageView = [[UIImageView alloc] initWithImage:slipImage];
        slipImageView.frame = CGRectMake(15.0f, 90, [UIScreen mainScreen].bounds.size.width-30, 1/[UIScreen mainScreen].scale);
        [self.contentView addSubview:slipImageView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setIsLeft:(BOOL)isLeft {
    _isLeft = isLeft;
    
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    if (_isLeft) {
        _surveyImageView.frame = CGRectMake(15.0f, 15.0f, 100, 60);
        _stockNameLabel.frame = CGRectMake(130.0f, 15.0f, w-145, 20);
        _stockNowPriLabel.frame = CGRectMake(130.0f, 50, w-145, 30);
    } else {
        _surveyImageView.frame = CGRectMake(w-115, 15.0f, 100, 60);
        _stockNameLabel.frame = CGRectMake(15.0f, 15.0f, w-145, 20);
        _stockNowPriLabel.frame = CGRectMake(15.0f, 50.0f, w-145, 30);
    }
    
    _surveyTitleLabel.frame = CGRectMake(15.0f, 100.0f, w-30, 20);
}

- (void)setupSurvey:(SurveyModel *)survey {
    _stockNameLabel.text = survey.companyName;
    
    NSString *title = [NSString stringWithFormat:@"调研：%@",survey.surveyTitle];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:title];
    [attri setAttributes:@{NSForegroundColorAttributeName:[UIColor hx_colorWithHexRGBAString:@"#1b69b1"]} range:NSMakeRange(0, 3)];
    [attri setAttributes:@{NSForegroundColorAttributeName:[UIColor hx_colorWithHexRGBAString:@"#323232"]} range:NSMakeRange(3, title.length-3)];
    _surveyTitleLabel.attributedText = attri;
    
    [_surveyImageView sd_setImageWithURL:[NSURL URLWithString:survey.surveyCover]];
}

- (void)setupStock:(StockInfo *)stock {
    float todayStartPri = [[NSDecimalNumber decimalNumberWithString:stock.todayStartPri] floatValue];
    float nowPri = [[NSDecimalNumber decimalNumberWithString:stock.nowPri] floatValue];
    
    if (!stock.nowPri.length) {
        // 没有值 退市，开盘前半小时
        NSString *string = [NSString stringWithFormat:@"0  0%% 0"];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:string];
        [attr setAttributes:@{NSForegroundColorAttributeName:[UIColor hx_colorWithHexRGBAString:@"#696969"],NSFontAttributeName:[UIFont systemFontOfSize:25.0f]}
                      range:NSMakeRange(0, 1)];
        [attr setAttributes:@{NSForegroundColorAttributeName:[UIColor hx_colorWithHexRGBAString:@"#696969"],NSFontAttributeName:[UIFont systemFontOfSize:15.0f]}
                      range:NSMakeRange(1,string.length-1)];
        _stockNowPriLabel.attributedText = attr;
    } else {
        float value = nowPri - todayStartPri;
        float valueB = value/todayStartPri;
        NSString *nowPriString = [NSString stringWithFormat:@"%.2lf",nowPri];
        NSString *string = [NSString stringWithFormat:@"%@ %+.2lf %+.2lf%%",nowPriString,value,valueB*100];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:string];
        
        if (value >= 0.00) {
            [attr setAttributes:@{NSForegroundColorAttributeName:[UIColor hx_colorWithHexRGBAString:@"#e64920"],NSFontAttributeName:[UIFont systemFontOfSize:25.0f]}
                          range:NSMakeRange(0, nowPriString.length)];
            [attr setAttributes:@{NSForegroundColorAttributeName:[UIColor hx_colorWithHexRGBAString:@"#e64920"],NSFontAttributeName:[UIFont systemFontOfSize:15.0f]}
                          range:NSMakeRange(nowPriString.length,string.length-nowPriString.length)];
            
        } else {
            [attr setAttributes:@{NSForegroundColorAttributeName:[UIColor hx_colorWithHexRGBAString:@"#1fcc67"],NSFontAttributeName:[UIFont systemFontOfSize:25.0f]}
                          range:NSMakeRange(0, nowPriString.length)];
            [attr setAttributes:@{NSForegroundColorAttributeName:[UIColor hx_colorWithHexRGBAString:@"#1fcc67"],NSFontAttributeName:[UIFont systemFontOfSize:15.0f]}
                          range:NSMakeRange(nowPriString.length,string.length-nowPriString.length)];
        }
        _stockNowPriLabel.attributedText = attr;
    }
}

@end
