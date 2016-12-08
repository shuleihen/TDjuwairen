//
//  OptionalStockTableViewCell.m
//  TDjuwairen
//
//  Created by 团大 on 2016/12/7.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "OptionalStockTableViewCell.h"

#import "Masonry.h"

@implementation OptionalStockTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.nameLab = [[UILabel alloc] init];
        self.nameLab.font = [UIFont systemFontOfSize:17];
        
        self.codeLab = [[UILabel alloc] init];
        self.codeLab.font = [UIFont systemFontOfSize:15];
        
        [self addSubview:self.nameLab];
        [self addSubview:self.codeLab];
        
        [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(10);
            make.left.equalTo(self).with.offset(15);
            make.width.mas_equalTo(kScreenWidth/3-15);
            make.height.mas_equalTo(20);
        }];
        
        [self.codeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLab.mas_bottom).with.offset(5);
            make.left.equalTo(self).with.offset(15);
            make.bottom.equalTo(self).with.offset(-10);
            make.width.mas_equalTo(kScreenWidth/3-15);
            make.height.mas_equalTo(15);
        }];
        
    }
    return self;
}

- (void)setupWithStock:(StockInfo *)stock{
    float yestodEndPri = [[NSDecimalNumber decimalNumberWithString:stock.yestodEndPri] floatValue];
    float nowPri = [[NSDecimalNumber decimalNumberWithString:stock.nowPri] floatValue];
    
    float value = nowPri - yestodEndPri;   //跌涨额
    float valueB = value/yestodEndPri;     //跌涨百分比
    
    self.nLab.text = [NSString stringWithFormat:@"%.2lf",nowPri];
    
    self.increaseLab.text = [NSString stringWithFormat:@"%.2f",value];
    
    self.increPerLab.text = [NSString stringWithFormat:@"%.2f%%",valueB*100];
    
    if (value > 0) {
        self.nLab.textColor = [UIColor redColor];
        self.increaseLab.textColor = [UIColor redColor];
        self.increPerLab.textColor = [UIColor redColor];
    }
    else if(value < 0){
        self.nLab.textColor = [UIColor greenColor];
        self.increaseLab.textColor = [UIColor greenColor];
        self.increPerLab.textColor = [UIColor greenColor];
    }
    else
    {
        self.nLab.textColor = [UIColor grayColor];
        self.increaseLab.textColor = [UIColor grayColor];
        self.increPerLab.textColor = [UIColor grayColor];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
