//
//  ExchangeTableViewCell.h
//  TDjuwairen
//
//  Created by 团大 on 2016/11/24.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ExchangeModel.h"

@protocol ExchangeTableViewCellDelegate <NSObject>

- (void)clickToExchangePrize:(UIButton *)sender;

@end

@interface ExchangeTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *prizeImg;

@property (nonatomic, strong) UILabel *prizeLab;

@property (nonatomic, strong) UIImageView *keysImg;

@property (nonatomic, strong) UILabel *keysNum;

@property (nonatomic, strong) UIButton *exchangeBtn;

@property (nonatomic, strong) UILabel *line;

@property (nonatomic, strong) id<ExchangeTableViewCellDelegate>delegate;

- (void)setupWithDiction:(ExchangeModel *)model andIndexPath:(NSIndexPath *)indexPath;

@end
