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
#import "AliveListForwardView2.h"
#import "AliveListPlayStockView.h"

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
        AliveListForwardView2 *view = [[AliveListForwardView2 alloc] initWithFrame:CGRectMake(0, cellData.topHeaderHeight, kScreenWidth, cellData.viewHeight)];
        self.aliveContentView = view;
        [view setCellData:cellData];
        
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forwardMsgPressed:)];
        [view.forwardView addGestureRecognizer:tap2];
    } else {
        switch (aliveModel.aliveType) {
            case kAliveNormal:
            case kAlivePosts: {
                AliveListPostView *view = [[AliveListPostView alloc] initWithFrame:CGRectMake(0, cellData.topHeaderHeight, kScreenWidth, cellData.viewHeight)];
                view.delegate = self;
                self.aliveContentView = view;
                [view setCellData:cellData];
            }
                break;
            case kAliveViewpoint: {
                AliveListViewpointView *view = [[AliveListViewpointView alloc] initWithFrame:CGRectMake(0, cellData.topHeaderHeight, kScreenWidth, cellData.viewHeight)];
                self.aliveContentView = view;
                [view setCellData:cellData];
            }
                break;
            case kAlivePlayStock: {
                AliveListPlayStockView *view = [[AliveListPlayStockView alloc] initWithFrame:CGRectMake(0, cellData.topHeaderHeight, kScreenWidth, cellData.viewHeight)];
                view.delegate = self;
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(aliveListTableCell:avatarPressed:)]) {
        [self.delegate aliveListTableCell:self avatarPressed:sender];
    }
}

- (void)aliveListHeaderView:(AliveListHeaderView *)headerView arrowPressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(aliveListTableCell:arrowPressed:)]) {
        [self.delegate aliveListTableCell:self arrowPressed:sender];
    }
}

#pragma mark - AliveListPlayStockViewDelegate
- (void)playStockPressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(aliveListTableCell:playStockPressed:)]) {
        [self.delegate aliveListTableCell:self playStockPressed:sender];
    }
}

- (void)forwardMsgPressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(aliveListTableCell:forwardMsgPressed:)]) {
        [self.delegate aliveListTableCell:self forwardMsgPressed:sender];
    }
}

- (void)forwardAvatarPressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(aliveListTableCell:forwardAvatarPressed:)]) {
        [self.delegate aliveListTableCell:self forwardAvatarPressed:sender];
    }
}

- (IBAction)avatarPressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(aliveListTableCell:avatarPressed:)]) {
        [self.delegate aliveListTableCell:self avatarPressed:sender];
    }
}

- (void)arrowPressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(aliveListTableCell:arrowPressed:)]) {
        [self.delegate aliveListTableCell:self arrowPressed:sender];
    }
}

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

//
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    UITouch *one = touches.anyObject;
//    
//    NSLog(@"touch view = %@",one.view);
//    
//    [super touchesBegan:touches withEvent:event];
//}

@end
