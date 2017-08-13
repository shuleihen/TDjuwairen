//
//  StockPoolExpireCell.h
//  TDjuwairen
//
//  Created by deng shu on 2017/8/13.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StockPoolSettingListModel;
@class StockPoolExpireCell;
@protocol StockPoolExpireCellDelegate <NSObject>
/// 续费
- (void)addMoney:(StockPoolExpireCell *)vc listModel:( StockPoolSettingListModel *)listModel;

@end
@interface StockPoolExpireCell : UITableViewCell
@property (nonatomic, strong) StockPoolSettingListModel *listModel;
@property (nonatomic, weak) id<StockPoolExpireCellDelegate> delegate;
@end
