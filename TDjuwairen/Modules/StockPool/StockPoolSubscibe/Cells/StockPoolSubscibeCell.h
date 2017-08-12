//
//  StockPoolSubscibeCell.h
//  TDjuwairen
//
//  Created by deng shu on 2017/8/12.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StockPoolSubscibeModel;
@class StockPoolSubscibeCell;

@protocol StockPoolSubscibeCellDelegate <NSObject>

- (void)attentionAction:(StockPoolSubscibeCell *)cell subscibeModel:(StockPoolSubscibeModel *)model;

@end

@interface StockPoolSubscibeCell : UITableViewCell
@property (nonatomic, assign) BOOL historyCell;
@property (nonatomic, strong) StockPoolSubscibeModel *model;
@property (nonatomic, weak) id<StockPoolSubscibeCellDelegate> delegate;

@end
