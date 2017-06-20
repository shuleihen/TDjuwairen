//
//  VideoTitleTableViewCell.h
//  TDjuwairen
//
//  Created by zdy on 2017/6/6.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoInfoModel.h"

@interface VideoTitleTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *visitBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

+ (CGFloat)cellHeightWithTitle:(NSString *)title;
- (void)setupModel:(VideoInfoModel *)model;
@end
