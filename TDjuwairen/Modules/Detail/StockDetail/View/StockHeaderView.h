//
//  StockHeaderView.h
//  TDjuwairen
//
//  Created by zdy on 2016/11/29.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StockManager.h"
#import "StockInfoModel.h"

@protocol StockHeaderDelegate <NSObject>

- (void)gradePressed:(id)sender;
- (void)addStockPressed:(id)sender;
- (void)invitePressed:(id)sender;
@end

@interface StockHeaderView : UIView
@property (nonatomic, weak) IBOutlet UILabel *nowPriLabel;
@property (nonatomic, weak) IBOutlet UILabel *valueLabel;
@property (nonatomic, weak) IBOutlet UILabel *valueBLabel;
@property (nonatomic, weak) IBOutlet UILabel *detailALabel;
@property (nonatomic, weak) IBOutlet UILabel *detailBLabel;
@property (nonatomic, weak) IBOutlet UIButton *gradeBtn;
@property (nonatomic, weak) IBOutlet UIButton *addBtn;
@property (nonatomic, weak) IBOutlet UILabel *gradeNumLabel;
@property (nonatomic, weak) IBOutlet UILabel *orderNumLabel;

@property (nonatomic, weak) id<StockHeaderDelegate> delegate;

- (void)setupStockInfo:(StockInfo *)stockInfo;
- (void)setupStockModel:(StockInfoModel *)model;
@end
