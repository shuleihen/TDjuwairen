//
//  SurveyListTableViewCell.h
//  TDjuwairen
//
//  Created by zdy on 2017/6/14.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StockManager.h"
#import "SurveyListModel.h"
#import "SurveyTypeDefine.h"

@interface SurveyListTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *surveyImageView;
@property (nonatomic, strong) UILabel *stockNameLabel;
@property (nonatomic, strong) UILabel *stockNowPriLabel;
@property (nonatomic, strong) UILabel *surveyTitleLabel;
@property (nonatomic, strong) SurveyListModel *model;

@property (nonatomic, weak) id<SurveyStockListCellDelegate> delegate;


- (void)setupSurvey:(SurveyListModel *)survey;
- (void)setupStock:(StockInfo *)stock;
@end
