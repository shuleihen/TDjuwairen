//
//  SearchCompanyListTableView.h
//  TDjuwairen
//
//  Created by ZYP-MAC on 17/3/23.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SearchCompanyListModel;
typedef void(^ChoiceCompanyCodeBlock)(SearchCompanyListModel *model);
typedef void(^ChoiceCompanyCodeNameBlock)(NSString *code,NSString *name);



@interface SearchCompanyListTableView : UITableView
@property (copy, nonatomic) ChoiceCompanyCodeBlock  choiceModel;
@property (copy, nonatomic) ChoiceCompanyCodeNameBlock  backBlock;

@property (copy, nonatomic) NSString *vcType;
- (instancetype)initWithSearchCompanyListTableViewWithFrame:(CGRect)rect;

- (void)configResultDataArr:(NSArray *)arr andRectY:(CGFloat)orginY;
- (void)configResultDataArr:(NSArray *)arr andRectY:(CGFloat)orginY andBottomH:(CGFloat)bottomH;

/// 更改tableview高度
- (void)changeTableViewHeightWithRectY:(CGFloat)orginY;



@end
