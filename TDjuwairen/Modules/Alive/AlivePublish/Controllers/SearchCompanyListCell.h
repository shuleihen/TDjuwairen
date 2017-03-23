//
//  SearchCompanyListCell.h
//  TDjuwairen
//
//  Created by ZYP-MAC on 17/3/23.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchCompanyListModel.h"
@interface SearchCompanyListCell : UITableViewCell
@property (strong, nonatomic) SearchCompanyListModel *resultModel;

+ (instancetype)loadSearchCompanyListCellWithTableView:(UITableView *)tableView;
@end
