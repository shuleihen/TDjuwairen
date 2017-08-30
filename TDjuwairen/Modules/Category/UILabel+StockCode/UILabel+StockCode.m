//
//  UILabel+StockCode.m
//  TDjuwairen
//
//  Created by zdy on 2017/7/14.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "UILabel+StockCode.h"

@implementation UILabel (StockCode)

- (void)setupForGuessDetailStockInfo:(StockInfo *)stock {
    [self setupStockInfo:stock
             withMaxFont:[UIFont systemFontOfSize:20 weight:UIFontWeightMedium]
                 minFont:[UIFont systemFontOfSize:12.0f]
             normalColor:[UIColor hx_colorWithHexRGBAString:@"#666666"]
                 upColor:[UIColor hx_colorWithHexRGBAString:@"#ff0000"]
               downColor:[UIColor hx_colorWithHexRGBAString:@"#14C76A"]];
}

- (void)setupForStockPoolDetailStockInfo:(StockInfo *)stock {
    [self setupStockInfo:stock
             withMaxFont:[UIFont systemFontOfSize:16 weight:UIFontWeightMedium]
                 minFont:[UIFont systemFontOfSize:9.0f]
             normalColor:[UIColor hx_colorWithHexRGBAString:@"#666666"]
                 upColor:[UIColor hx_colorWithHexRGBAString:@"#E74922"]
               downColor:[UIColor hx_colorWithHexRGBAString:@"#13C869"]];
}

- (void)setupStockInfo:(StockInfo *)stock
           withMaxFont:(UIFont *)maxFont
               minFont:(UIFont *)minFont
           normalColor:(UIColor *)normalColor
               upColor:(UIColor *)upColor
             downColor:(UIColor *)downColor {
    if (![stock enabled]) {
        self.font = [UIFont systemFontOfSize:14.0f];
        self.textColor = normalColor;
        self.text = @"--";
    } else {
        float value = [stock priValue];            //跌涨额
        float valueB = [stock priPercentValue];     //跌涨百分比
        NSString *nowPriString = [NSString stringWithFormat:@"%.2lf",stock.nowPriValue];
        
        NSString *string = [NSString stringWithFormat:@"%@  %+.2lf  %+.2lf%%",nowPriString,value,valueB*100];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:string];
        
        
        [attr setAttributes:@{NSFontAttributeName:maxFont} range:NSMakeRange(0, nowPriString.length)];
        [attr setAttributes:@{NSFontAttributeName:minFont} range:NSMakeRange(nowPriString.length,string.length-nowPriString.length)];
        
        if (value >= 0.00) {
            self.textColor = upColor;
        } else {
            self.textColor = downColor;
        }
        self.attributedText = attr;
    }
}

@end
