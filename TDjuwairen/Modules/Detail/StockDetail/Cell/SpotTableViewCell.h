//
//  SpotTableViewCell.h
//  TDjuwairen
//
//  Created by zdy on 2017/1/13.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpotModel.h"

@interface SpotTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *spotImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;

- (void)setupSpotModel:(SpotModel *)model;
@end
