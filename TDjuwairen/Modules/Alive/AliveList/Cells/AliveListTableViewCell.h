//
//  AliveListTableViewCell.h
//  TDjuwairen
//
//  Created by zdy on 2017/3/9.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AliveListModel.h"
#import "AliveListImagesView.h"
#import "AliveListCellData.h"
#import "AliveListForwardView.h"
#import "TTTAttributedLabel.h"
#import "AliveListTagsView.h"
#import "AliveListViewpointImageView.h"
#import "AliveListContentView.h"

@class AliveListTableViewCell;
@protocol AliveListTableCellDelegate <NSObject>
- (void)aliveListTableCell:(AliveListTableViewCell *)cell avatarPressed:(id)sender;
- (void)aliveListTableCell:(AliveListTableViewCell *)cell arrowPressed:(id)sender;
- (void)aliveListTableCell:(AliveListTableViewCell *)cell forwardAvatarPressed:(id)sender;
- (void)aliveListTableCell:(AliveListTableViewCell *)cell forwardMsgPressed:(id)sender;
@end

@interface AliveListTableViewCell : UITableViewCell<TTTAttributedLabelDelegate>
@property (strong, nonatomic) UIImageView *avatar;
@property (strong, nonatomic) UILabel *nickNameLabel;
@property (strong, nonatomic) UIImageView *officialImageView;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UIButton *arrowButton;

@property (strong, nonatomic) TTTAttributedLabel *messageLabel;
@property (strong, nonatomic) NSLayoutConstraint *imagesHeight;
@property (strong, nonatomic) AliveListImagesView *imagesView;
@property (strong, nonatomic) AliveListForwardView *forwardView;
@property (strong, nonatomic) AliveListTagsView *tagsView;
@property (strong, nonatomic) AliveListViewpointImageView *viewpointImageView;

@property (strong, nonatomic) AliveListCellData *cellData;

@property (nonatomic, strong) AliveListContentView *aliveContentView;

@property (weak, nonatomic) id<AliveListTableCellDelegate> delegate;


- (void)setupAliveListCellData:(AliveListCellData *)cellData;

@end
