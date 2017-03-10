//
//  AliveMasterListTableViewCell.h
//  TDjuwairen
//
//  Created by zdy on 2017/3/9.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AliveMasterModel;

@interface AliveMasterListTableViewCell : UITableViewCell
@property (strong, nonatomic) AliveMasterModel *aliveModel;

+ (instancetype)loadAliveMasterListTableViewCell:(UITableView *)tableView;

@end
