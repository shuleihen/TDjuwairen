//
//  AliveListStockPoolTableViewCell.h
//  TDjuwairen
//
//  Created by zdy on 2017/8/11.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDAvatar.h"
#import "AliveListStockPoolModel.h"

@interface AliveListStockPoolTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet TDAvatar *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *subscriptionNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *residueDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *payInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *subscribeLabel;

- (void)setupAliveStockPool:(AliveListStockPoolModel *)stockPool;
@end
