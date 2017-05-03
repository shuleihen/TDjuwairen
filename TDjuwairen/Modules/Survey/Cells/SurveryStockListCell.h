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

@class SurveryStockListCell;
@protocol SurveyStockListCellDelegate <NSObject>

- (void)surveyStockListCell:(SurveryStockListCell *)cell stockNamePressed:(id)sender;
- (void)surveyStockListCell:(SurveryStockListCell *)cell titlePressed:(id)sender;
@end

@interface SurveryStockListCell : UITableViewCell
@property (nonatomic, strong) UIImageView *surveyImageView;
@property (nonatomic, strong) UILabel *stockNameLabel;
@property (nonatomic, strong) UILabel *stockNowPriLabel;
@property (nonatomic, strong) UILabel *stockDetailLabel;
@property (nonatomic, strong) UILabel *surveyTitleLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIImageView *typeImageView;
@property (nonatomic, strong) SurveyModel *model;

@property (nonatomic, weak) id<SurveyStockListCellDelegate> delegate;

+ (CGFloat)rowHeight;

- (void)setupSurvey:(SurveyModel *)survey;
- (void)setupStock:(StockInfo *)stock;
@end
