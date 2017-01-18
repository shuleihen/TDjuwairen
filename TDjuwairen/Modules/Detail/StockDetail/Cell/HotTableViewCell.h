//
//  HotTableViewCell.h
//  TDjuwairen
//
//  Created by zdy on 2017/1/18.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StockHotModel.h"

@interface HotTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;

- (void)setupSpotModel:(StockHotModel *)model;
@end
