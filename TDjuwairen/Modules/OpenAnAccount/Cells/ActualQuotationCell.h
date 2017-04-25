//
//  ActualQuotationCell.h
//  TDjuwairen
//
//  Created by deng shu on 2017/4/23.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirmPlatListModel.h"

@protocol ActualQuotationCellDelegate <NSObject>

- (void)openAnAccountButtonClickDone:(FirmPlatListModel *)model;
- (void)callnNumButtonClickDone:(FirmPlatListModel *)model;

@end

@interface ActualQuotationCell : UITableViewCell
@property (weak,nonatomic)id<ActualQuotationCellDelegate> delegate;
@property (nonatomic, strong) FirmPlatListModel *firmModel;
+ (instancetype)loadActualQuotationCellWithTableView:(UITableView *)tableView;

@end
