//
//  AliveListHeaderView.h
//  TDjuwairen
//
//  Created by zdy on 2017/7/25.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AliveListModel.h"

@class AliveListHeaderView;
@protocol AliveListHeaderViewDelegate <NSObject>

- (void)aliveListHeaderView:(AliveListHeaderView *)headerView avatarPressed:(id)sender;
- (void)aliveListHeaderView:(AliveListHeaderView *)headerView arrowPressed:(id)sender;

@end

@interface AliveListHeaderView : UIView
@property (strong, nonatomic) UIImageView *avatar;
@property (strong, nonatomic) UILabel *nickNameLabel;
@property (strong, nonatomic) UIImageView *officialImageView;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UIButton *arrowButton;
@property (strong, nonatomic) AliveListModel *aliveModel;

@property (nonatomic, weak) id<AliveListHeaderViewDelegate> delegate;
@end
