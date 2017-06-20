//
//  VideoTitleTableViewCell.m
//  TDjuwairen
//
//  Created by zdy on 2017/6/6.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "VideoTitleTableViewCell.h"

@implementation VideoTitleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)cellHeightWithTitle:(NSString *)title {
    CGFloat height;
    
    CGSize size = [title boundingRectWithSize:CGSizeMake(kScreenWidth-24, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f]} context:nil].size;
    height = size.height + 54;
    return height;
}

- (void)setupModel:(VideoInfoModel *)model {
    self.titleLabel.text = model.content;
    [self.visitBtn setTitle:[NSString stringWithFormat:@"%@",model.visitNum] forState:UIControlStateNormal];
    [self.shareBtn setTitle:[NSString stringWithFormat:@"%@",model.shareNum] forState:UIControlStateNormal];
}
@end
