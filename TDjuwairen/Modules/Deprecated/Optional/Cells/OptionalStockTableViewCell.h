//
//  OptionalStockTableViewCell.h
//  TDjuwairen
//
//  Created by 团大 on 2016/12/7.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StockManager.h"

@interface OptionalStockTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *nameLab;

@property (nonatomic,strong) UILabel *codeLab;

@property (nonatomic,strong) UILabel *nLab;

@property (nonatomic,strong) UILabel *increaseLab;

@property (nonatomic,strong) UILabel *increPerLab;

- (void)setupWithStock:(StockInfo *)stock;

@end
