//
//  GradeListCell.h
//  TDjuwairen
//
//  Created by zdy on 2017/1/12.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GradeListModel.h"

@interface GradeListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *sortNumberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sortNumberImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;

- (void)setupGradeListModel:(GradeListModel *)assessed;
@end
