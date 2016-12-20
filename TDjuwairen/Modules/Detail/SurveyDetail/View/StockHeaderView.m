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
    self.nowPriLabel.text = [NSString stringWithFormat:@"%+.2lf",stockInfo.nowPriValue];
    
    float value = [stockInfo priValue];             //跌涨额
    float valueB = [stockInfo priPercentValue];     //跌涨百分比
    self.valueLabel.text = [NSString stringWithFormat:@"%+.2lf",value];
    self.valueBLabel.text = [NSString stringWithFormat:@"%+.2lf%%",valueB*100];
    
    float traNumber = [stockInfo.traNumber floatValue]/100;
    float traAmount = [stockInfo.traAmount floatValue]/10000;
    
    NSString *detailA = [NSString stringWithFormat:@"昨收 %@   最高 %@    成交量 %.2lf手",stockInfo.yestodEndPri,stockInfo.todayMax,traNumber];
    NSString *detailB = [NSString stringWithFormat:@"今开 %@   最低 %@    成交额 %.2lf万",stockInfo.todayStartPri,stockInfo.todayMin,traAmount];
    self.detailALabel.text = detailA;
    self.detailBLabel.text = detailB;
    
    if (value >= 0.0) {
        self.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#e64920"];
    } else {
        self.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#1fcc67"];
    }
}

@end
