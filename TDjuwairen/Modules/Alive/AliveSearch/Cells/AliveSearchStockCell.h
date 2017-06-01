//
//  AliveSearchStockCell.h
//  TDjuwairen
//
//  Created by ZYP-MAC on 17/5/26.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AliveSearchResultModel;
@protocol AliveSearchStockCellDelegate <NSObject>
/// 添加自选
- (void)addChoiceStockWithSearchResultModel:(AliveSearchResultModel *)model andCellIndex:(NSInteger)index;
/// 调研
- (void)surveyButtonClickWithSearchResultModel:(AliveSearchResultModel *)model;

@end

@interface AliveSearchStockCell : UITableViewCell
@property (weak, nonatomic) id<AliveSearchStockCellDelegate> delegate;
@property (strong, nonatomic) AliveSearchResultModel *stockModel;

+ (instancetype)loadAliveSearchStockCellWithTableView:(UITableView *)tableView;
@end
