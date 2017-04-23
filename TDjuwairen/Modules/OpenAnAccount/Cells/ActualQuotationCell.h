//
//  ActualQuotationCell.h
//  TDjuwairen
//
//  Created by deng shu on 2017/4/23.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ActualQuotationCellDelegate <NSObject>

- (void)openAnAccountButtonClickDone:(id)model;
- (void)callnNumButtonClickDone:(id)model;

@end

@interface ActualQuotationCell : UITableViewCell
@property (weak,nonatomic)id<ActualQuotationCellDelegate> delegate;
+ (instancetype)loadActualQuotationCellWithTableView:(UITableView *)tableView;

@end
