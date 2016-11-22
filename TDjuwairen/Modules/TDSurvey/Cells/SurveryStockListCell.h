//
//  SurveryStockListCell.h
//  TDjuwairen
//
//  Created by zdy on 2016/11/22.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StockManager.h"
#import "SurveyModel.h"

@interface SurveryStockListCell : UITableViewCell
@property (nonatomic, strong) UIImageView *surveyImageView;
@property (nonatomic, strong) UILabel *stockNameLabel;
@property (nonatomic, strong) UILabel *stockNowPriLabel;
@property (nonatomic, strong) UILabel *stockDetailLabel;
@property (nonatomic, strong) UILabel *surveyTitleLabel;

@property (nonatomic, assign) BOOL isLeft;

- (void)setupSurvey:(SurveyModel *)survey;
- (void)setupStock:(StockInfo *)stock;
@end
