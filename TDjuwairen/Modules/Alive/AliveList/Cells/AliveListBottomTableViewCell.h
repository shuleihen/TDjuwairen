//
//  AliveListBottomTableViewCell.h
//  TDjuwairen
//
//  Created by zdy on 2017/3/9.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AliveListModel.h"

@class AliveListBottomTableViewCell;
@protocol AliveListBottomTableCellDelegate <NSObject>
- (void)aliveListBottomTableCell:(AliveListBottomTableViewCell *)cell sharePressed:(id)sender;
- (void)aliveListBottomTableCell:(AliveListBottomTableViewCell *)cell commentPressed:(id)sender;
- (void)aliveListBottomTableCell:(AliveListBottomTableViewCell *)cell likePressed:(id)sender;
@end

@interface AliveListBottomTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) id<AliveListBottomTableCellDelegate> delegate;

@property (nonatomic, strong) AliveListModel *cellModel;

- (void)setupAliveModel:(AliveListModel *)aliveModel;
- (void)setupForDetail;
@end
