//
//  GradeDetailCell.h
//  TDjuwairen
//
//  Created by zdy on 2017/1/16.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GradeCommentModel.h"
#import "GradeCommReplyView.h"

@interface GradeDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *stockGodLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;
@property (weak, nonatomic) IBOutlet GradeCommReplyView *replyView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *replyViewHeight;
@property (nonatomic, copy) void (^replyBlock)(void);

+ (CGFloat)heightWithCommentModel:(GradeCommentModel *)model;
- (void)setupCommentModel:(GradeCommentModel *)model;
@end
