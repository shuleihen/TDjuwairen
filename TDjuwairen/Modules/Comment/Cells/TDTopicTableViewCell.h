//
//  TDTopicTableViewCell.h
//  TDjuwairen
//
//  Created by zdy on 2017/8/22.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDTopicModel.h"

@interface TDTopicTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) UILabel *nickNameLabel;
@property (nonatomic, strong) UILabel *topicTitleLabel;
@property (nonatomic, strong) UILabel *topicTimeLabel;
@property (nonatomic, strong) UIButton *replayBtn;

@property (nonatomic, strong) TDTopicModel *topicModel;
@end
