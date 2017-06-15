//
//  SurveryStockListCell.h
//  TDjuwairen
//
//  Created by zdy on 2016/11/22.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StockManager.h"
#import "SurveyListModel.h"
#import "SurveyTypeDefine.h"

@interface SurveryStockListCell : UITableViewCell
@property (nonatomic, strong) UIImageView *surveyImageView;
@property (nonatomic, strong) UILabel *stockNameLabel;
@property (nonatomic, strong) UILabel *surveyTitleLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIImageView *typeImageView;
@property (nonatomic, strong) UIImageView *lockImageView;
@property (nonatomic, strong) SurveyListModel *model;

@property (nonatomic, weak) id<SurveyStockListCellDelegate> delegate;

+ (CGFloat)rowHeight;

- (void)setupSurvey:(SurveyListModel *)survey;
@end
