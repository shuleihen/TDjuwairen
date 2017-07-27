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
#import "TTTAttributedLabel.h"
#import "AliveListTagsView.h"
#import "AliveListContentView.h"
#import "AliveListBottomView.h"
#import "AliveListHeaderView.h"
#import "AliveListPlayStockView.h"

@class AliveListTableViewCell;
@protocol AliveListTableCellDelegate <NSObject>
- (void)aliveListTableCell:(AliveListTableViewCell *)cell avatarPressed:(id)sender;
- (void)aliveListTableCell:(AliveListTableViewCell *)cell arrowPressed:(id)sender;
- (void)aliveListTableCell:(AliveListTableViewCell *)cell forwardAvatarPressed:(id)sender;
- (void)aliveListTableCell:(AliveListTableViewCell *)cell forwardMsgPressed:(id)sender;
- (void)aliveListTableCell:(AliveListTableViewCell *)cell sharePressed:(id)sender;
- (void)aliveListTableCell:(AliveListTableViewCell *)cell commentPressed:(id)sender;
- (void)aliveListTableCell:(AliveListTableViewCell *)cell likePressed:(id)sender;
- (void)aliveListTableCell:(AliveListTableViewCell *)cell stockPressedWithStockCode:(NSString *)stockCode;
- (void)aliveListTableCell:(AliveListTableViewCell *)cell playStockPressed:(id)sender;
- (void)aliveListTableCellIndexPath:(NSIndexPath *)indexPath closePressed:(id)sender;

@end

@interface AliveListTableViewCell : UITableViewCell
<AliveListTagsViewDelegate, AliveListHeaderViewDelegate, AliveListPlayStockViewDelegate>

@property (nonatomic, strong) AliveListHeaderView *aliveHeaderView;

@property (nonatomic, strong) AliveListContentView *aliveContentView;

@property (nonatomic, strong) AliveListBottomView *aliveBottomView;

@property (strong, nonatomic) AliveListCellData *cellData;

@property (weak, nonatomic) id<AliveListTableCellDelegate> delegate;

- (void)setupAliveListCellData:(AliveListCellData *)cellData;

@end
