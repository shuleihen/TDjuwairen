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
        _stockPoolView = [[AliveListForwardStockPoolView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:_stockPoolView];
    }
    
    return self;
}


- (void)setCellData:(AliveListCellData *)cellData {
    [super setCellData:cellData];
    
    AliveListStockPoolCellData *vpCellData = (AliveListStockPoolCellData *)cellData;
    AliveListModel *alive = cellData.aliveModel;
    
    self.stockPoolView.frame = vpCellData.stockPoolViewFrame;
    self.stockPoolView.aliveModel = alive;
}
@end
