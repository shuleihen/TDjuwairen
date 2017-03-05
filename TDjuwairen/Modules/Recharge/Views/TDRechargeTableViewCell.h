//
//  TDRechargeTableViewCell.h
//  TDjuwairen
//
//  Created by zdy on 2017/3/5.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDRechargeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *keyLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;

@end
