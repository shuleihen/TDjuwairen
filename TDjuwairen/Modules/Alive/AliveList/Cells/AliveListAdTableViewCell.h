//
//  AliveListAdTableViewCell.h
//  TDjuwairen
//
//  Created by zdy on 2017/7/19.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AliveListModel.h"
#import "AliveListTableViewCell.h"

@interface AliveListAdTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *adImageView;

@property (nonatomic, weak) id<AliveListTableCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)setupAliveModel:(AliveListModel *)model;
@end
