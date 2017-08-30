//
//  SPDetailTableViewCell.h
//  TDjuwairen
//
//  Created by zdy on 2017/8/16.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPEditRecordModel.h"

@interface SPDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *stockNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *stockPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratioLabel;
@property (weak, nonatomic) IBOutlet UILabel *optionLabel;
@property (nonatomic, strong) SPEditRecordModel *recordModel;
@end
