//
//  AliveMasterListTableViewCell.h
//  TDjuwairen
//
//  Created by zdy on 2017/3/9.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AliveMasterModel;

typedef void(^AttentionAliveMasterBlock)();

@interface AliveMasterListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *introLabel;
@property (strong, nonatomic) AliveMasterModel *aliveModel;
@property (copy, nonatomic) AttentionAliveMasterBlock  attentedBlock;

+ (instancetype)loadAliveMasterListTableViewCell:(UITableView *)tableView;

@end
