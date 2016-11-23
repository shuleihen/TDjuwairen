//
//  OrderDetailTableViewCell.h
//  TDjuwairen
//
//  Created by 团大 on 2016/11/22.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

@protocol OrderDetailCellDelegate <NSObject>

- (void)clickDeleteOrder:(UIButton *)sender;

@end

@interface OrderDetailTableViewCell : UITableViewCell

@property (nonatomic,strong) UIView *backView;

@property (nonatomic,strong) UILabel *IDLab;

@property (nonatomic,strong) UILabel *orderID;

@property (nonatomic,strong) UILabel *orderStatus;

@property (nonatomic,strong) UILabel *line1;

@property (nonatomic,strong) UILabel *orderTitle;

@property (nonatomic,strong) UILabel *timeLab;

@property (nonatomic,strong) UILabel *orderTime;

@property (nonatomic,strong) UIImageView *moneyImg;

@property (nonatomic,strong) UILabel *orderMoney;

@property (nonatomic,strong) UILabel *line2;

@property (nonatomic,strong) UIButton *cleanBtn;

@property (nonatomic,assign) id<OrderDetailCellDelegate>delegate;

- (void)setupUIWithModel:(OrderModel *)model andIndexPath:(NSIndexPath *)indexPath;

@end
