//
//  TDTopicTableViewCell.h
//  TDjuwairen
//
//  Created by zdy on 2017/8/22.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDTopicCellData.h"

@protocol TDTopicTableViewCellDelegate <NSObject>

- (void)replyWithCommentId:(NSString *)commentId;

@end

@interface TDTopicTableViewCell : UITableViewCell<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) UILabel *nickNameLabel;
@property (nonatomic, strong) UILabel *topicTitleLabel;
@property (nonatomic, strong) UILabel *topicTimeLabel;
@property (nonatomic, strong) UIButton *replyBtn;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, weak) id<TDTopicTableViewCellDelegate> delegate;

@property (nonatomic, strong) TDTopicCellData *topicCellData;
@end
