//
//  AliveListForwardStockPoolView.h
//  TDjuwairen
//
//  Created by zdy on 2017/8/12.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AliveListModel.h"

@interface AliveListForwardStockPoolView : UIView
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, strong) AliveListModel *aliveModel;
@end
