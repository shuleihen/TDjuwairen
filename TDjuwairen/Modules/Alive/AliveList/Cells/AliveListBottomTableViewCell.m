//
//  AliveListBottomTableViewCell.m
//  TDjuwairen
//
//  Created by zdy on 2017/3/9.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveListBottomTableViewCell.h"

@implementation AliveListBottomTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupAliveModel:(AliveListModel *)aliveModel {
    [self.shareBtn setTitle:[NSString stringWithFormat:@"%ld", aliveModel.shareNum] forState:UIControlStateNormal];
    [self.commentBtn setTitle:[NSString stringWithFormat:@"%ld", aliveModel.commentNum] forState:UIControlStateNormal];
    [self.likeBtn setTitle:[NSString stringWithFormat:@"%ld", aliveModel.likeNum] forState:UIControlStateNormal];
}
@end
