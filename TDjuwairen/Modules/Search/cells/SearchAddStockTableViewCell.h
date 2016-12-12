//
//  SearchAddStockTableViewCell.h
//  TDjuwairen
//
//  Created by 团大 on 2016/12/12.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SurveyListModel.h"

@protocol addStockDelegate <NSObject>

- (void)clickAddOptionalStock:(UIButton *)sender;

@end

@interface SearchAddStockTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *code;

@property (nonatomic,strong) UILabel *name;

@property (nonatomic,strong) UIButton *addBtn;

@property (nonatomic,strong) UILabel *line;

@property (nonatomic,assign) id<addStockDelegate>delegate;

- (void)setupWithModel:(SurveyListModel *)model;

@end
