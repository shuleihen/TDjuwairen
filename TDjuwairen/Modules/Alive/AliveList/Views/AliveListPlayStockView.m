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
        _contentView = [[UIView alloc] init];
        [self addSubview:_contentView];
        
        _adImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 178)];
        [_contentView addSubview:_adImageView];
        
        _stockNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 186, frame.size.width, 14)];
        _stockNameLabel.font = [UIFont systemFontOfSize:13.0f];
        _stockNameLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#999999"];
        _stockNameLabel.textAlignment = NSTextAlignmentLeft;
        _stockNameLabel.userInteractionEnabled = YES;
        [_contentView addSubview:_stockNameLabel];

        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 186, frame.size.width, 14)];
        _timeLabel.font = [UIFont systemFontOfSize:13.0f];
        _timeLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#999999"];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        [_contentView addSubview:_timeLabel];
    }
    
    return self;
}

- (void)setCellData:(AliveListCellData *)cellData {
    [super setCellData:cellData];
    
    AliveListPlayStockCellData *vpCellData = (AliveListPlayStockCellData *)cellData;
    AliveListModel *alive = cellData.aliveModel;
    AliveListPlayStockExtra *extra = alive.extra;
    
    self.contentView.frame = vpCellData.contentViewFrame;
    
    [self.adImageView sd_setImageWithURL:[NSURL URLWithString:alive.aliveImgs.firstObject] placeholderImage:nil];
    self.stockNameLabel.text = [NSString stringWithFormat:@"个股竞猜【%@(%@)】",extra.companyName,extra.companyCode];
    self.timeLabel.text = [NSString stringWithFormat:@"%@ %@",extra.guessTime,extra.guessSeason];
}

@end
