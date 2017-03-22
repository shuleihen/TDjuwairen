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
        
        self.daynightModel = [UIdaynightModel sharedInstance];
        // 调用公司缩略图
        _surveyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 60)];
        [self.contentView addSubview:_surveyImageView];
        
        // 上市公司名称和股票代码
        _stockNameLabel = [[UILabel alloc] init];
        _stockNameLabel.font = [UIFont systemFontOfSize:17.0f];
        _stockNameLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"333333"];
        [self.contentView addSubview:_stockNameLabel];
        
        // 当前交易价格
        _stockNowPriLabel = [[UILabel alloc] init];
        _stockNowPriLabel.font = [UIFont systemFontOfSize:25.0f];
        [self.contentView addSubview:_stockNowPriLabel];
        
        /* 当前涨幅值和百分百
        _stockDetailLabel = [[UILabel alloc] init];
        _stockDetailLabel.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:_stockDetailLabel];
        */
        
        // 调用文章标题
        _surveyTitleLabel = [[UILabel alloc] init];
        _surveyTitleLabel.font = [UIFont systemFontOfSize:12.0f];
        [self.contentView addSubview:_surveyTitleLabel];
        
        
        self.contentView.backgroundColor = [UIColor whiteColor];
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
        _stockNameLabel.frame = CGRectMake(130.0f, 17.0f, w-145, 20);
        _stockNowPriLabel.frame = CGRectMake(130.0f, 44, w-145, 30);
    } else {
        _surveyImageView.frame = CGRectMake(w-115, 15.0f, 100, 60);
        _stockNameLabel.frame = CGRectMake(15.0f, 17.0f, w-135, 20);
        _stockNowPriLabel.frame = CGRectMake(15.0f, 44.0f, w-135, 30);
    }
    
    _surveyTitleLabel.frame = CGRectMake(15.0f, 87.0f, w-30, 20);
}

- (void)setupSurvey:(SurveyModel *)survey {
    _stockNameLabel.text = [NSString stringWithFormat:@"%@(%@)",survey.companyName,[survey.companyCode stockCode]];
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] init];
    
    if (survey.surveyType == 1) {
        // 调研
        NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"调研 " attributes:@{NSForegroundColorAttributeName: [UIColor hx_colorWithHexRGBAString:@"#cccccc"]}];
        [attri appendAttributedString:title];
    } else if (survey.surveyType == 2) {
        // 热点
        NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"热点 " attributes:@{NSForegroundColorAttributeName: [UIColor hx_colorWithHexRGBAString:@"#cccccc"]}];
        [attri appendAttributedString:title];
    } else {
    }
    
    NSAttributedString *content = [[NSAttributedString alloc] initWithString:survey.surveyTitle attributes:@{NSForegroundColorAttributeName: [UIColor hx_colorWithHexRGBAString:@"#333333"]}];
    [attri appendAttributedString:content];
    _surveyTitleLabel.attributedText = attri;
    
    [_surveyImageView sd_setImageWithURL:[NSURL URLWithString:survey.surveyCover]];
}

- (void)setupStock:(StockInfo *)stock {
    
    if (!stock.nowPri.length) {
        // 没有值 退市，开盘前半小时
        NSString *string = [NSString stringWithFormat:@"0  0 0%%"];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:string];
        [attr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:26.0f]} range:NSMakeRange(0, 1)];
        [attr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]} range:NSMakeRange(1,string.length-1)];
        
        _stockNameLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#222222"];
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
            font1 = [UIFont systemFontOfSize:26];
            font2 = [UIFont systemFontOfSize:14];
        }
        else
        {
            font1 = [UIFont systemFontOfSize:28];
            font2 = [UIFont systemFontOfSize:16];
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

@end