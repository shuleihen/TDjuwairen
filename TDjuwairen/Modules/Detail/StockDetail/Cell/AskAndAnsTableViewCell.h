//
//  AskAndAnsTableViewCell.h
//  TDjuwairen
//
//  Created by zdy on 2017/4/25.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SurveyAnsView.h"
#import "AskModel.h"

@interface AskAndAnsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *askAvatar;
@property (weak, nonatomic) IBOutlet UILabel *askUserNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *askCommentLable;
@property (weak, nonatomic) IBOutlet SurveyAnsView *ansView;
@property (weak, nonatomic) IBOutlet UILabel *addTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ansViewHeight;
@property (nonatomic, strong) AskModel *askModel;

+ (CGFloat)cellHeightWithSurveyAskModel:(AskModel *)model;
- (void)setupAskModel:(AskModel *)model;
@end
