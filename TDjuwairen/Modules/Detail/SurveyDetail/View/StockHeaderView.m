//
//  StockHeaderView.m
//  TDjuwairen
//
//  Created by zdy on 2016/11/29.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "StockHeaderView.h"
#import "HexColors.h"

@implementation StockHeaderView

- (void)setupStockInfo:(StockInfo *)stockInfo {
    self.nowPriLabel.text = [NSString stringWithFormat:@"%.2lf",stockInfo.nowPriValue];
    
    float value = [stockInfo priValue];             //跌涨额
    float valueB = [stockInfo priPercentValue];     //跌涨百分比
    self.valueLabel.text = [NSString stringWithFormat:@"%+.2lf",value];
    self.valueBLabel.text = [NSString stringWithFormat:@"%+.2lf%%",valueB*100];
    
    float yestodEndPri = [stockInfo.yestodEndPri floatValue];
    float todayMax = [stockInfo.todayMax floatValue];
    float todayStartPri = [stockInfo.todayStartPri floatValue];
    float todayMin = [stockInfo.todayMin floatValue];
    float traNumber = [stockInfo.traNumber floatValue]/10000;
    float traAmount = [stockInfo.traAmount floatValue]/10000;
    
    NSString *detailA = [NSString stringWithFormat:@"昨收 %.2lf   最高 %.2lf    成交量 %.4lf万股",yestodEndPri,todayMax,traNumber];
    NSString *detailB = [NSString stringWithFormat:@"今开 %.2lf   最低 %.2lf    成交额 %.2lf万",todayStartPri,todayMin,traAmount];
    self.detailALabel.text = detailA;
    self.detailBLabel.text = detailB;
    
    if (value >= 0.0) {
        self.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#e64920"];
    } else {
        self.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#1fcc67"];
    }
}

@end
