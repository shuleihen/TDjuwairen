//
//  AliveListAdTableViewCell.h
//  TDjuwairen
//
//  Created by zdy on 2017/7/19.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AliveListModel.h"

@interface AliveListAdTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *adImageView;

- (void)setupAliveModel:(AliveListModel *)model;
@end
