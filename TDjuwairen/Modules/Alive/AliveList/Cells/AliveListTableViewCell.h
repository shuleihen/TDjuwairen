//
//  AliveListTableViewCell.h
//  TDjuwairen
//
//  Created by zdy on 2017/3/9.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AliveListModel.h"
#import "AliveListImagesView.h"

@interface AliveListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imagesHeight;
@property (weak, nonatomic) IBOutlet AliveListImagesView *imagesView;

+ (CGFloat)heightWithAliveModel:(AliveListModel *)aliveModel;
- (void)setupAliveModel:(AliveListModel *)aliveModel;
@end
