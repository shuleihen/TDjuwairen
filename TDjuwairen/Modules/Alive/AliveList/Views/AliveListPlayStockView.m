//
//  AliveListPlayStockView.m
//  TDjuwairen
//
//  Created by zdy on 2017/7/19.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveListPlayStockView.h"
#import "UIImageView+WebCache.h"

@implementation AliveListPlayStockView


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _adImageView = [[UIImageView alloc] init];
        [self addSubview:_adImageView];
        
        _stockNameLabel = [[UILabel alloc] init];
        _stockNameLabel.font = [UIFont systemFontOfSize:13.0f];
        _stockNameLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#999999"];
        _stockNameLabel.textAlignment = NSTextAlignmentLeft;
        _stockNameLabel.userInteractionEnabled = YES;
        [self addSubview:_stockNameLabel];
     
        UITapGestureRecognizer *nickTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stockNamePressed:)];
        [_stockNameLabel addGestureRecognizer:nickTap];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:13.0f];
        _timeLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#999999"];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_timeLabel];
    }
    
    return self;
}

- (void)setCellData:(AliveListCellData *)cellData {
    [super setCellData:cellData];
    
    AliveListPlayStockCellData *vpCellData = (AliveListPlayStockCellData *)cellData;
    AliveListModel *alive = cellData.aliveModel;
    AliveListPlayStockExtra *extra = alive.extra;
    
    self.adImageView.frame = vpCellData.adImageFrame;
    self.stockNameLabel.frame = vpCellData.stockNameLabelFrame;
    self.timeLabel.frame = vpCellData.timeLabelFrame;
    
    [self.adImageView sd_setImageWithURL:[NSURL URLWithString:alive.aliveImgs.firstObject] placeholderImage:nil];
    self.stockNameLabel.text = [NSString stringWithFormat:@"个股竞猜【%@(%@)】",extra.companyName,extra.companyCode];
    self.timeLabel.text = [NSString stringWithFormat:@"%@ %@",extra.guessTime,extra.guessSeason];
}

- (void)stockNamePressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(playStockPressed:)]) {
        [self.delegate playStockPressed:sender];
    }
}
@end
