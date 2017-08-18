//
//  SpotTableViewCell.h
//  TDjuwairen
//
//  Created by zdy on 2017/1/13.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StockSurveyModel.h"

@interface SpotTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *spotImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UIImageView *lockImageView;

- (void)setupSpotModel:(StockSurveyModel *)model;
@end
