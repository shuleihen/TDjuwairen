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

@class AliveListTableViewCell;
@protocol AliveListTableCellDelegate <NSObject>
- (void)aliveListTableCell:(AliveListTableViewCell *)cell avatarPressed:(id)sender;
- (void)aliveListTableCell:(AliveListTableViewCell *)cell forwardAvatarPressed:(id)sender;
- (void)aliveListTableCell:(AliveListTableViewCell *)cell forwardMsgPressed:(id)sender;
@end

@interface AliveListTableViewCell : UITableViewCell<TTTAttributedLabelDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *avatar;
@property (strong, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet TTTAttributedLabel *messageLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imagesHeight;
@property (strong, nonatomic) IBOutlet AliveListImagesView *imagesView;
@property (strong, nonatomic) IBOutlet UILabel *tiedanLabel;
@property (strong, nonatomic) AliveListForwardView *forwardView;
@property (strong, nonatomic) AliveListCellData *cellData;

@property (weak, nonatomic) id<AliveListTableCellDelegate> delegate;


- (void)setupAliveListCellData:(AliveListCellData *)cellData;

@end
