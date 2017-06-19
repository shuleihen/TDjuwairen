//
//  AliveMessageListCell.h
//  TDjuwairen
//
//  Created by zdy on 2017/3/13.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageListModel.h"

@interface MessageListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *aliveContentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *aliveImageView;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

- (void)setupMessageModel:(MessageListModel *)message;

@end