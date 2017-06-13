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

- (IBAction)sharePressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(aliveListBottomTableCell:sharePressed:)]) {
        [self.delegate aliveListBottomTableCell:self sharePressed:sender];
    }
}

- (IBAction)commentPressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(aliveListBottomTableCell:commentPressed:)]) {
        [self.delegate aliveListBottomTableCell:self commentPressed:sender];
    }
}

- (IBAction)likePressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(aliveListBottomTableCell:likePressed:)]) {
        [self.delegate aliveListBottomTableCell:self likePressed:sender];
    }
}

- (void)setupAliveModel:(AliveListModel *)aliveModel {
    
    _cellModel = aliveModel;
    [self.shareBtn setTitle:[NSString stringWithFormat:@"%ld", (long)aliveModel.shareNum] forState:UIControlStateNormal];
    [self.commentBtn setTitle:[NSString stringWithFormat:@"%ld", (long)aliveModel.commentNum] forState:UIControlStateNormal];
    [self.likeBtn setTitle:[NSString stringWithFormat:@"%ld", (long)aliveModel.likeNum] forState:UIControlStateNormal];
    self.likeBtn.selected = aliveModel.isLike;
}

- (void)setupForDetail {
    [self.shareBtn setTitle:@"转发" forState:UIControlStateNormal];
    [self.commentBtn setTitle:@"评论" forState:UIControlStateNormal];
    [self.likeBtn setTitle:@"点赞" forState:UIControlStateNormal];
}
@end
