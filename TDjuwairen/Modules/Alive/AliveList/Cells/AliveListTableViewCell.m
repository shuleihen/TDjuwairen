  //
//  AliveListTableViewCell.m
//  TDjuwairen
//
//  Created by zdy on 2017/3/9.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveListTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "HexColors.h"
#import "MYPhotoBrowser.h"
#import "AliveListPostView.h"
#import "AliveListViewpointView.h"
#import "AliveListForwardView.h"
#import "AliveListPlayStockView.h"
#import "AliveListStockPoolView.h"
#import "AliveListVisitCardView.h"

@implementation AliveListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

    }
    return self;
}

- (void)setAliveContentView:(AliveListContentView *)aliveContentView {
    if (_aliveContentView || _aliveContentView.superview) {
        [_aliveContentView removeFromSuperview];
    }
    
    _aliveContentView = aliveContentView;
    
    if (aliveContentView) {
        aliveContentView.messageLabel.delegate = self;
        [self.contentView addSubview:aliveContentView];
    }
}

- (AliveListHeaderView *)aliveHeaderView {
    if (!_aliveHeaderView) {
        _aliveHeaderView = [[AliveListHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.cellData.topHeaderHeight)];
        _aliveHeaderView.delegate = self;
        
        [self.contentView addSubview:_aliveHeaderView];
    }
    return _aliveHeaderView;
}

- (AliveListBottomView *)aliveBottomView {
    if (!_aliveBottomView) {
        _aliveBottomView = [[AliveListBottomView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.cellData.bottomHeight)];
        [_aliveBottomView.shareBtn addTarget:self action:@selector(sharePressed:) forControlEvents:UIControlEventTouchUpInside];
        [_aliveBottomView.commentBtn addTarget:self action:@selector(commentPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_aliveBottomView.likeBtn addTarget:self action:@selector(likePressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_aliveBottomView];
    }
    return _aliveBottomView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupAliveListCellData:(AliveListCellData *)cellData {
    
    self.cellData = cellData;
    AliveListModel *aliveModel = cellData.aliveModel;
    
    // 表头
    if (cellData.isShowHeaderView) {
        self.aliveHeaderView.hidden = NO;
        self.aliveHeaderView.aliveModel = aliveModel;
    } else {
        self.aliveHeaderView.hidden = YES;
    }
    
    // 动态内容
    if (aliveModel.isForward) {
        AliveListForwardView *view = [[AliveListForwardView alloc] initWithFrame:CGRectMake(0, cellData.topHeaderHeight, kScreenWidth, cellData.viewHeight)];
        self.aliveContentView = view;
        [view setCellData:cellData];
        
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forwardMsgPressed:)];
        [view.forwardView addGestureRecognizer:tap2];
    } else {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentTagGesture:)];
        
        switch (aliveModel.aliveType) {
            case kAliveNormal:
            case kAlivePosts:
            case kAliveStockHolder:
            {
                AliveListPostView *view = [[AliveListPostView alloc] initWithFrame:CGRectMake(0, cellData.topHeaderHeight, kScreenWidth, cellData.viewHeight)];
                view.delegate = self;
                self.aliveContentView = view;
                [view setCellData:cellData];
            }
                break;
            case kAliveViewpoint:
            {
                AliveListViewpointView *view = [[AliveListViewpointView alloc] initWithFrame:CGRectMake(0, cellData.topHeaderHeight, kScreenWidth, cellData.viewHeight)];
                self.aliveContentView = view;
                [view setCellData:cellData];
            }
                break;
            case kAlivePlayStock:
            {
                AliveListPlayStockView *view = [[AliveListPlayStockView alloc] initWithFrame:CGRectMake(0, cellData.topHeaderHeight, kScreenWidth, cellData.viewHeight)];
                [view.contentView addGestureRecognizer:tap];
                self.aliveContentView = view;
                [view setCellData:cellData];
            }
                break;
            case kAliveStockPool:
            case kAliveStockPoolRecord:
            {
                AliveListStockPoolView *view = [[AliveListStockPoolView alloc] initWithFrame:CGRectMake(0, cellData.topHeaderHeight, kScreenWidth, cellData.viewHeight)];
                [view.contentView addGestureRecognizer:tap];
                self.aliveContentView = view;
                [view setCellData:cellData];
            }
                break;
            case kAliveVisitCard:
            {
                AliveListVisitCardView *view = [[AliveListVisitCardView alloc] initWithFrame:CGRectMake(0, cellData.topHeaderHeight, kScreenWidth, cellData.viewHeight)];
                [view.contentView addGestureRecognizer:tap];
                self.aliveContentView = view;
                [view setCellData:cellData];
            }
                break;
            default:
                break;
        }
    }
    
    // 底部工具条
    if (cellData.isShowBottomView) {
        self.aliveBottomView.hidden = NO;
        self.aliveBottomView.frame = CGRectMake(0, cellData.topHeaderHeight+cellData.viewHeight, kScreenWidth, cellData.bottomHeight);
        
        [self.aliveBottomView.shareBtn setTitle:[NSString stringWithFormat:@"%ld", (long)aliveModel.shareNum] forState:UIControlStateNormal];
        [self.aliveBottomView.commentBtn setTitle:[NSString stringWithFormat:@"%ld", (long)aliveModel.commentNum] forState:UIControlStateNormal];
        [self.aliveBottomView.likeBtn setTitle:[NSString stringWithFormat:@"%ld", (long)aliveModel.likeNum] forState:UIControlStateNormal];
        self.aliveBottomView.likeBtn.selected = aliveModel.isLike;
    } else {
        self.aliveBottomView.hidden = YES;
    }
}


#pragma mark - Tap
- (void)contentTagGesture:(id)sender {
    // AliveListStockPoolView，AliveListVisitCardView 添加了手势

    AliveListModel *alive = self.cellData.aliveModel;
    
    
    if (alive.aliveType == kAliveVisitCard) {
        AliveListVisitCardExtra *extra = alive.extra;
        if (self.delegate && [self.delegate respondsToSelector:@selector(aliveListTableCell:userPressedWithUserId:)]) {
            [self.delegate aliveListTableCell:self userPressedWithUserId:extra.masterId];
        }
    } else if (alive.aliveType == kAliveStockPool) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(aliveListTableCell:stockPoolPressed:)]) {
            [self.delegate aliveListTableCell:self stockPoolPressed:sender];
        }
    } else if (alive.aliveType == kAliveStockPoolRecord) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(aliveListTableCell:stockPoolDetailPressed:)]) {
            [self.delegate aliveListTableCell:self stockPoolDetailPressed:sender];
        }
    } else if (alive.aliveType == kAlivePlayStock) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(aliveListTableCell:playStockPressed:)]) {
            [self.delegate aliveListTableCell:self playStockPressed:sender];
        }
    }
}


#pragma mark - AliveListTagsViewDelegate
- (void)aliveListTagsView:(AliveListTagsView *)tagsView didSelectedWithIndex:(NSInteger)index {
    AliveListPostExtra *extra = self.cellData.aliveModel.extra;
    if (index < 0 &&
        index > extra.aliveStockTags.count) {
        return;
    }
    
    NSString *code = extra.aliveStockTags[index];
    if (self.delegate && [self.delegate respondsToSelector:@selector(aliveListTableCell:stockPressedWithStockCode:)]) {
        [self.delegate aliveListTableCell:self stockPressedWithStockCode:code];
    }
}

#pragma mark - AliveListHeaderViewDelegate
- (void)aliveListHeaderView:(AliveListHeaderView *)headerView avatarPressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(aliveListTableCell:userPressedWithUserId:)]) {
        [self.delegate aliveListTableCell:self userPressedWithUserId:self.cellData.aliveModel.masterId];
    }
}

- (void)aliveListHeaderView:(AliveListHeaderView *)headerView arrowPressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(aliveListTableCell:arrowPressed:)]) {
        [self.delegate aliveListTableCell:self arrowPressed:sender];
    }
}


- (void)forwardMsgPressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(aliveListTableCell:forwardMsgPressed:)]) {
        [self.delegate aliveListTableCell:self forwardMsgPressed:sender];
    }
}


- (IBAction)avatarPressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(aliveListTableCell:userPressedWithUserId:)]) {
        [self.delegate aliveListTableCell:self userPressedWithUserId:self.cellData.aliveModel.masterId];
    }
}

- (void)arrowPressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(aliveListTableCell:arrowPressed:)]) {
        [self.delegate aliveListTableCell:self arrowPressed:sender];
    }
}

#pragma mark - BottomTool
- (void)sharePressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(aliveListTableCell:sharePressed:)]) {
        [self.delegate aliveListTableCell:self sharePressed:sender];
    }
}

- (void)commentPressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(aliveListTableCell:commentPressed:)]) {
        [self.delegate aliveListTableCell:self commentPressed:sender];
    }
}

- (void)likePressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(aliveListTableCell:likePressed:)]) {
        [self.delegate aliveListTableCell:self likePressed:sender];
    }
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    
    if ([url.host isEqualToString:@"alive_image"]) {
        NSInteger tag = [url.lastPathComponent integerValue];
        
        if (tag >= 0 && tag <= self.cellData.aliveModel.forwardImgs.count) {
            NSString *imageName = self.cellData.aliveModel.forwardImgs[tag];
            MYPhotoBrowser *photoBrowser = [[MYPhotoBrowser alloc] initWithUrls:@[imageName]
                                                                       imgViews:nil
                                                                    placeholder:nil
                                                                     currentIdx:0
                                                                    handleNames:nil
                                                                       callback:^(UIImage *handleImage,NSString *handleType) {
                                                                       }];
            [photoBrowser showWithAnimation:YES];
        }
    } else if ([url.host isEqualToString:@"alive_user"]) {
        NSInteger tag = [url.lastPathComponent integerValue];
        
        if (tag >= 0 && tag <= self.cellData.aliveModel.forwardImgs.count) {
            NSString *userId = self.cellData.aliveModel.forwardUsers[tag];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(aliveListTableCell:userPressedWithUserId:)]) {
                [self.delegate aliveListTableCell:self userPressedWithUserId:userId];
            }
        }
        
    }
}
@end
