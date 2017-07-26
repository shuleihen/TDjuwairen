//
//  StockHeaderView.m
//  TDjuwairen
//
//  Created by zdy on 2016/11/29.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "StockHeaderView.h"
#import "HexColors.h"
#import "Masonry.h"

@implementation StockHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.valueLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#333333"];
    self.valueBLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#333333"];
    
    self.gradeBtn.layer.cornerRadius = 12.0f;
    self.gradeBtn.layer.borderColor = [UIColor hx_colorWithHexRGBAString:@"#3371e2"].CGColor;
    self.gradeBtn.layer.borderWidth = 1;
    self.gradeBtn.clipsToBounds = YES;
}

- (void)setupStockInfo:(StockInfo *)stockInfo {
    
    if ([stockInfo.nowPri floatValue] <= 0.0) {
        // 没有值 退市，停盘,开盘前半小时
        NSString *string = [NSString stringWithFormat:@"0  0 0%%"];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:string];
        [attr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:26.0f]} range:NSMakeRange(0, 1)];
        [attr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]} range:NSMakeRange(1,string.length-1)];
        
        UIColor *color = [UIColor hx_colorWithHexRGBAString:@"#222222"];
        
        self.nowPriLabel.textColor = color;
        self.valueLabel.textColor = color;
        self.valueBLabel.textColor = color;
        
        self.nowPriLabel.text = [NSString stringWithFormat:@"--"];
        self.valueLabel.text = @"--";
        self.valueBLabel.text = @"--";
        
        float yestodEndPri = [stockInfo.yestodEndPri floatValue];
        
        NSString *detailA = [NSString stringWithFormat:@"昨收 %.2lf   最高 --    成交量 --",yestodEndPri];
        NSString *detailB = [NSString stringWithFormat:@"今开 --         最低 --    成交额 --"];
        NSString *detailC = [NSString stringWithFormat:@"总值 %@亿  流值 %@亿    市盈(动) %@",stockInfo.allValue,stockInfo.currentValue,stockInfo.dynamicRatio];
        self.detailALabel.text = detailA;
        self.detailBLabel.text = detailB;
        self.detailCLabel.text = detailC;
    } else {
        // 当前价格
        self.nowPriLabel.text = [NSString stringWithFormat:@"%.2lf",stockInfo.nowPriValue];
        
        float value = [stockInfo priValue];             //跌涨额
        float valueB = [stockInfo priPercentValue];     //跌涨百分比
        self.valueLabel.text = [NSString stringWithFormat:@"%+.2lf",value];
        self.valueBLabel.text = [NSString stringWithFormat:@"%+.2lf%%",valueB*100];

        UIColor *color = nil;
        if (value >= 0.0) {
            color = [UIColor hx_colorWithHexRGBAString:@"#e74922"];
        } else {
            color = [UIColor hx_colorWithHexRGBAString:@"#13C869"];
        }
        
        self.nowPriLabel.textColor = color;
        self.valueLabel.textColor = color;
        self.valueBLabel.textColor = color;
        
        float yestodEndPri = [stockInfo.yestodEndPri floatValue];
        float todayMax = [stockInfo.todayMax floatValue];
        float todayStartPri = [stockInfo.todayStartPri floatValue];
        float todayMin = [stockInfo.todayMin floatValue];
        float traNumber = stockInfo.traNumber/10000;
        float traAmount = stockInfo.traAmount/10000;
        
        NSString *detailA = [NSString stringWithFormat:@"昨收 %.2lf   最高 %.2lf    成交量 %.4lf万股",yestodEndPri,todayMax,traNumber];
        NSString *detailB = [NSString stringWithFormat:@"今开 %.2lf   最低 %.2lf    成交额 %.2lf万",todayStartPri,todayMin,traAmount];
        NSString *detailC = [NSString stringWithFormat:@"总值 %@亿  流值 %@亿    市盈(动) %@",stockInfo.allValue,stockInfo.currentValue,stockInfo.dynamicRatio];
        self.detailALabel.text = detailA;
        self.detailBLabel.text = detailB;
        self.detailCLabel.text = detailC;
    }
}

- (void)setupStockModel:(StockInfoModel *)model {
    NSString *score = [NSString stringWithFormat:@"评分 %@",model.score];
    [self.gradeBtn setTitle:score forState:UIControlStateNormal];
    
    self.gradeNumLabel.text = [NSString stringWithFormat:@"已有%@人参与",model.joinGradeNum];
    if ([model.joinGradeNum integerValue] != 0) {
        // 没有人参与评分，排名隐藏
        self.orderNumLabel.text = [NSString stringWithFormat:@"排名%@/%@",model.orderNum,model.allCompanyNum];
    } else {
        self.orderNumLabel.text = @"";
    }
    
    self.isAdd = model.isAdd;
    
    if (model.isAdd) {
        [self.addBtn setTitle:@"取消自选" forState:UIControlStateNormal];
        [self.addBtn setImage:nil forState:UIControlStateNormal];
    } else {
        [self.addBtn setTitle:nil forState:UIControlStateNormal];
        [self.addBtn setImage:[UIImage imageNamed:@"add_shares2.png"] forState:UIControlStateNormal];
        self.addBtn.enabled = YES;
    }
}

- (IBAction)gradePressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(gradePressed:)]) {
        [self.delegate gradePressed:sender];
    }
}

- (IBAction)addPressed:(id)sender {
    if (self.isAdd) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(removeStockPressed:)]) {
            [self.delegate removeStockPressed:sender];
        }
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(addStockPressed:)]) {
            [self.delegate addStockPressed:sender];
        }
    }
}

- (IBAction)invitePressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(invitePressed:)]) {
        [self.delegate invitePressed:sender];
    }
}
@end
