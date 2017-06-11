//
//  AliveListPostView.m
//  TDjuwairen
//
//  Created by zdy on 2017/6/6.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveListPostView.h"

@implementation AliveListPostView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _imagesView = [[AliveListImagesView alloc] initWithFrame:CGRectZero];
        [self addSubview:_imagesView];
        
        _tagsView = [[AliveListTagsView alloc] initWithFrame:CGRectZero];
        [self addSubview:_tagsView];

    }
    
    return self;
}

- (void)setCellData:(AliveListCellData *)cellData {
    [super setCellData:cellData];
    
    AliveListPostCellData *pCellData = (AliveListPostCellData *)cellData;
    
    self.imagesView.frame = pCellData.imagesViewFrame;
    self.imagesView.images = pCellData.aliveModel.aliveImgs;
    
    self.tagsView.frame = pCellData.tagsViewFrame;
    self.tagsView.tags = pCellData.aliveModel.aliveTags;
}
@end
