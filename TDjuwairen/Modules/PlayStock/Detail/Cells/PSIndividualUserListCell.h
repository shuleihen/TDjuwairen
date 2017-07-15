//
//  PSIndividualUserListCell.h
//  TDjuwairen
//
//  Created by zdy on 2017/7/15.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGCellWinKeyView.h"
#import "PSIndividualUserListModel.h"

@interface PSIndividualUserListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *winImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointLabel;
@property (weak, nonatomic) IBOutlet MGCellWinKeyView *winKeyView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *winkeyViewHeight;

- (void)setupUserModel:(PSIndividualUserListModel *)model;
@end
