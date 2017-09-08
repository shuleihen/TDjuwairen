//
//  AliveListStockPoolView.m
//  TDjuwairen
//
//  Created by zdy on 2017/8/12.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveListStockPoolView.h"

@implementation AliveListStockPoolView
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _contentView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#f8f8f8"];
        [self addSubview:_contentView];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 16, 40, 40)];
        _imageView.image = [UIImage imageNamed:@"ico_gupiaochi.png"];
        [_contentView addSubview:_imageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(64, 12, frame.size.width-76, 16)];
        _titleLabel.textColor = TDTitleTextColor;
        _titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [_contentView addSubview:_titleLabel];
        
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(64, 35, frame.size.width-76, 42)];
        _detailLabel.font = [UIFont systemFontOfSize:14.0f];
        _detailLabel.textColor = TDDetailTextColor;
        _detailLabel.numberOfLines = 2;
        [_contentView addSubview:_detailLabel];
    }
    
    return self;
}


- (void)setCellData:(AliveListCellData *)cellData {
    [super setCellData:cellData];
    
    AliveListStockPoolCellData *vpCellData = (AliveListStockPoolCellData *)cellData;
    AliveListModel *alive = cellData.aliveModel;
    AliveListStockPoolExtra *extra = alive.extra;
    
    self.contentView.frame = vpCellData.stockPoolViewFrame;
    
    
    self.titleLabel.text = extra.title;
    self.detailLabel.text = extra.desc.length?extra.desc:TDDefaultAliveListStockPoolDesc;
    CGSize size = [self.detailLabel sizeThatFits:CGSizeMake(CGRectGetWidth(self.frame)-76, 42)];
    self.detailLabel.frame = CGRectMake(64, 35, size.width, size.height);
}
@end
