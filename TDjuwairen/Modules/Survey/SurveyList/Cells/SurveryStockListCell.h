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
/// 文章类型
@property (strong, nonatomic) UILabel *article_typeLabel;
/// 文章描述
@property (strong, nonatomic) UILabel *article_titleLabel;


@property (nonatomic, strong) SurveyListModel *model;
/// 模块类型 :自选 推荐 。。。
@property (copy, nonatomic) NSString *subjectTitle;

@property (nonatomic, weak) id<SurveyStockListCellDelegate> delegate;

+ (CGFloat)rowHeight;

- (void)setupSurvey:(SurveyListModel *)survey;
- (void)setupStock:(StockInfo *)stock;
@end
