//
//  AliveRoomHeaderView.h
//  TDjuwairen
//
//  Created by ZYP-MAC on 17/3/10.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AliveRoomMasterModel;
@class AliveRoomHeaderView;
@protocol AliveRoomHeaderViewDelegate <NSObject>
- (void)aliveRommHeaderView:(AliveRoomHeaderView *)headerView attentionListPressed:(id)sender;
- (void)aliveRommHeaderView:(AliveRoomHeaderView *)headerView fansListPressed:(id)sender;
- (void)aliveRommHeaderView:(AliveRoomHeaderView *)headerView levelPressed:(id)sender;
- (void)aliveRommHeaderView:(AliveRoomHeaderView *)headerView guestRulePressed:(id)sender;

@optional
- (void)aliveRommHeaderView:(AliveRoomHeaderView *)headerView attenPressed:(id)sender;
- (void)aliveRommHeaderView:(AliveRoomHeaderView *)headerView editPressed:(id)sender;
- (void)aliveRommHeaderView:(AliveRoomHeaderView *)headerView messagePressed:(id)sender;
- (void)aliveRommHeaderView:(AliveRoomHeaderView *)headerView backPressed:(id)sender;
@end

@interface AliveRoomHeaderView : UIView

@property (strong, nonatomic) AliveRoomMasterModel *headerModel;
@property (nonatomic, weak) id<AliveRoomHeaderViewDelegate> delegate;

+ (instancetype)loadAliveRoomeHeaderView;
- (void)setupRoomMasterModel:(AliveRoomMasterModel *)master;
@end
