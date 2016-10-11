//
//  SurveyListCell.h
//  TDjuwairen
//
//  Created by zdy on 16/10/11.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SurveyListModel.h"

@interface SurveyListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userAvatar;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;

- (void)setupSurveyListModel:(SurveyListModel *)model;
@end
