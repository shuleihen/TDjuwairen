//
//  AliveListForwardStockPoolView.m
//  TDjuwairen
//
//  Created by zdy on 2017/8/12.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveListForwardStockPoolView.h"

@implementation AliveListForwardStockPoolView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 16, 40, 40)];
        _imageView.image = [UIImage imageNamed:@""];
        [self addSubview:_imageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(64, 12, frame.size.width-76, 16)];
        _titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:_titleLabel];
        
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(64, 35, frame.size.width-76, 42)];
        _detailLabel.font = [UIFont systemFontOfSize:14.0f];
        _detailLabel.textColor = TDDetailTextColor;
        _detailLabel.numberOfLines = 2;
        [self addSubview:_detailLabel];
    }
    return self;
}

- (void)setAliveModel:(AliveListModel *)aliveModel {
    _aliveModel = aliveModel;
    
    AliveListStockPoolExtra *extra = aliveModel.extra;
    
    self.titleLabel.text = extra.title;
    self.detailLabel.text = extra.desc;
}
@end
