//
//  AliveListForwardView.m
//  TDjuwairen
//
//  Created by zdy on 2017/6/7.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveListForwardView.h"
#import "AliveListForwardSurveyView.h"
#import "AliveListPostView.h"
#import "AliveListViewpointView.h"
#import "AliveVideoListTableViewCell.h"
#import "AliveListPlayStockView.h"
#import "AliveListStockPoolView.h"
#import "AliveListVisitCardView.h"
#import "AliveListForwardVideoView.h"
#import "AliveListViewpointTableViewCell.h"

@implementation AliveListForwardView


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
        case kAliveStockHolder:
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
        case kAliveViewpoint: {
            AliveListViewpointTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"AliveListViewpointTableViewCell" owner:nil options:nil].firstObject;
            cell.frame = fCellData.forwardViewFrame;
            self.forwardView = cell;
            [cell setupAliveModel:model];
        }
            break;
        case kAliveVideo:
        {
            AliveListForwardVideoView *view = [[AliveListForwardVideoView alloc] initWithFrame:fCellData.forwardViewFrame];
            self.forwardView = view;
            [view setAliveModel:model];
        }
            break;
        case kAlivePlayStock:
        {
            AliveListPlayStockView *view = [[AliveListPlayStockView alloc] initWithFrame:fCellData.forwardViewFrame];
            self.forwardView = view;
            [view setCellData:fCellData.forwardCellData];
        }
            break;
        case kAliveStockPool:
        case kAliveStockPoolRecord:
        {
            AliveListStockPoolView *view = [[AliveListStockPoolView alloc] initWithFrame:fCellData.forwardViewFrame];
            self.forwardView = view;
            [view setCellData:fCellData.forwardCellData];
        }
            break;
        case kAliveVisitCard:
        {
            AliveListVisitCardView *view = [[AliveListVisitCardView alloc] initWithFrame:fCellData.forwardViewFrame];
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
