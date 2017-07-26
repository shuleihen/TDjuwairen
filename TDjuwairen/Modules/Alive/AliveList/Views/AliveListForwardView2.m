//
//  AliveListForwardView2.m
//  TDjuwairen
//
//  Created by zdy on 2017/6/7.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveListForwardView2.h"
#import "AliveListForwardSurveyView.h"
#import "AliveListPostView.h"
#import "AliveListViewpointView.h"
#import "AliveVideoListTableViewCell.h"
#import "AliveListPlayStockView.h"

@implementation AliveListForwardView2


- (void)setForwardView:(UIView *)forwardView {
    if (_forwardView && !_forwardView.superview) {
        [_forwardView removeFromSuperview];
    }
    
    _forwardView = forwardView;
    [self addSubview:forwardView];
}

- (void)setCellData:(AliveListCellData *)cellData {
    [super setCellData:cellData];
    
    AliveListForwardCellData *fCellData = (AliveListForwardCellData *)cellData;
    AliveListModel *model = fCellData.aliveModel.forwardModel.forwardList.lastObject;
    
    switch (model.aliveType) {
        case kAliveNormal:
        case kAlivePosts:
        {
            AliveListPostView *view = [[AliveListPostView alloc] initWithFrame:fCellData.forwardViewFrame];
            self.forwardView = view;
            [view setCellData:fCellData.forwardCellData];
        }
            break;
        case kAliveSurvey:
        case kAliveHot:
        case kAliveDeep:
        {
            AliveListForwardSurveyView *view = [[AliveListForwardSurveyView alloc] initWithFrame:fCellData.forwardViewFrame];
            self.forwardView = view;
            [view setAliveModel:model];
        }
            break;
        case kAliveViewpoint:
        case kAliveVideo:
        {
            AliveListViewpointView *view = [[AliveListViewpointView alloc] initWithFrame:fCellData.forwardViewFrame];
            self.forwardView = view;
            [view setCellData:fCellData.forwardCellData];
        }
            break;
        case kAlivePlayStock:
        {
            AliveListPlayStockView *view = [[AliveListPlayStockView alloc] initWithFrame:fCellData.forwardViewFrame];
            self.forwardView = view;
            [view setCellData:fCellData.forwardCellData];
        }
            break;
        default:
            NSAssert(NO, @"当前转发的类型不支持");
            break;
    }
    
    self.forwardView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#f1f1f1"];
}

@end
