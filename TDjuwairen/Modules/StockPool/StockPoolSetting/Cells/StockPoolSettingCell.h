//
//  StockPoolSettingCell.h
//  TDjuwairen
//
//  Created by ZYP-MAC on 2017/8/11.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+Ext.h"

typedef void(^ChangeBillingTypeBlock)();

@interface StockPoolSettingCell : UITableViewCell
@property (strong, nonatomic) UILabel *sTitleLabel;
@property (strong, nonatomic) UILabel *billingLabel;
@property (strong, nonatomic) UITextView *sDescTextView;
@property (strong, nonatomic) UISwitch *sSwitch;
@property (copy, nonatomic) ChangeBillingTypeBlock  changeBillingBlock;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

+ (CGFloat)loadStockPoolSettingCellHeight:(NSString *)descStr;

@end
