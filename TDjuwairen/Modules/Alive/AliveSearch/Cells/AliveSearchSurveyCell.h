//
//  AliveSearchSurveyCell.h
//  TDjuwairen
//
//  Created by ZYP-MAC on 17/6/1.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AliveSearchResultModel;
@interface AliveSearchSurveyCell : UITableViewCell
@property (strong, nonatomic) AliveSearchResultModel *surveyModel;
+ (instancetype)loadAliveSearchSurveyCellWithTableView:(UITableView *)tableView;
+ (CGFloat)heightWithAliveModel:(AliveSearchResultModel *)model;

@end
