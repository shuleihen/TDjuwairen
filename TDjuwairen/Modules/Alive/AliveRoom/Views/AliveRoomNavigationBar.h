//
//  AliveRoomNavigationBar.h
//  TDjuwairen
//
//  Created by zdy on 2017/6/6.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AliveRoomMasterModel.h"

@class AliveRoomNavigationBar;
@protocol AliveRoomNavigationBarDelegate <NSObject>

- (void)aliveRoomNavigationBar:(AliveRoomNavigationBar *)navigationBar attenPressed:(id)sender;
- (void)aliveRoomNavigationBar:(AliveRoomNavigationBar *)navigationBar editPressed:(id)sender;
- (void)aliveRoomNavigationBar:(AliveRoomNavigationBar *)navigationBar messagePressed:(id)sender;
- (void)aliveRoomNavigationBar:(AliveRoomNavigationBar *)navigationBar backPressed:(id)sender;
@end

@interface AliveRoomNavigationBar : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *addAttenBtn;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;
@property (weak, nonatomic) IBOutlet UIImageView *bg;

@property (weak, nonatomic) id<AliveRoomNavigationBarDelegate> delegate;

+ (instancetype)loadAliveRoomeNavigationBar;
- (void)setupRoomMasterModel:(AliveRoomMasterModel *)master;
- (void)showNavigationBar:(BOOL)isShow withTitle:(NSString *)title;
@end
