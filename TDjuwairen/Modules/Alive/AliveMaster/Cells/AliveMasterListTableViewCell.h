//
//  AliveMasterListTableViewCell.h
//  TDjuwairen
//
//  Created by zdy on 2017/3/9.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "DeformationButton.h"

@class AliveMasterModel;
@class AliveMasterListTableViewCell;
@protocol AliveMasterListCellDelegate <NSObject>

- (void)aliveMasterListCell:(AliveMasterListTableViewCell *)cell attentPressed:(id)sender;

@end

@interface AliveMasterListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *introLabel;
@property (weak, nonatomic) IBOutlet UIButton *attentBtn;
@property (weak, nonatomic) IBOutlet UILabel *aLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *aFansCountLabel;
@property (strong, nonatomic) AliveMasterModel *aliveModel;

@property (nonatomic, weak) id<AliveMasterListCellDelegate> delegate;

+ (instancetype)loadAliveMasterListTableViewCell:(UITableView *)tableView;

@end
