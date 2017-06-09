//
//  AliveListViewpointView.m
//  TDjuwairen
//
//  Created by zdy on 2017/6/6.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveListViewpointView.h"
#import "UIImageView+WebCache.h"

@implementation AliveListViewpointView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];
    }
    
    return self;
}

- (void)setCellData:(AliveListCellData *)cellData {
    [super setCellData:cellData];
    
    AliveListViewpointCellData *vpCellData = (AliveListViewpointCellData *)cellData;
    AliveListModel *alive = cellData.aliveModel;
        
    self.imageView.frame = vpCellData.imageViewFrame;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:alive.aliveImgs.firstObject] placeholderImage:nil];
}
@end
