//
//  ViewPointTableViewCell.h
//  TDjuwairen
//
//  Created by 团大 on 16/7/25.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewPointListModel.h"

@class ViewPointTableViewCell;
@protocol ViewpointListTableCellDelegate <NSObject>
- (void)viewpointListTableCell:(ViewPointTableViewCell *)cell avatarPressed:(id)sender;
- (void)viewpointListTableCell:(ViewPointTableViewCell *)cell arrowPressed:(id)sender;
@end

@interface ViewPointTableViewCell : UITableViewCell

@property (strong, nonatomic) UIImageView *avatar;
@property (strong, nonatomic) UILabel *nickNameLabel;
@property (strong, nonatomic) UIImageView *officialImageView;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *messageLabel;
@property (strong, nonatomic) UIImageView *coverImageView;

@property (weak, nonatomic) id<ViewpointListTableCellDelegate> delegate;

+ (CGFloat)heightWithViewpointModel:(ViewPointListModel *)model;

- (void)setupViewPointModel:(ViewPointListModel *)model;
@end
