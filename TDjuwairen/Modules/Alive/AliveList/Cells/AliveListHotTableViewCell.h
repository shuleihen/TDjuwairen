//
//  AliveListHotTableViewCell.h
//  TDjuwairen
//
//  Created by zdy on 2017/7/19.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AliveListModel.h"

@interface AliveListHotTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *stockNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stockNameWidth;

- (void)setupAliveModel:(AliveListModel *)model;
@end
