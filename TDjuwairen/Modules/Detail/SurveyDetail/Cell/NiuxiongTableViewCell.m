//
//  NiuxiongTableViewCell.m
//  TDjuwairen
//
//  Created by zdy on 2016/12/22.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "NiuxiongTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation NiuxiongTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.avatar.clipsToBounds = YES;
    self.avatar.layer.cornerRadius = 11.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (CGFloat)heightWithContent:(NSString *)content {
    CGFloat height = 0;
    
    CGSize size =  [content boundingRectWithSize:CGSizeMake(kScreenWidth-47-15, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f]} context:nil].size;
    
    height = size.height + 38 + 15;
    return height;
}

- (void)setupComment:(StockCommentModel *)comment {
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:comment.userAvatar]];
    self.userNameLabel.text = comment.userName;
    self.contentLabel.text = comment.content;
    self.favourBtn.selected = comment.isLiked;
    self.dateTimeLabel.text = comment.createTime;
    
    if (comment.goodNums > 10000) {
        [self.favourBtn setTitle:@"999+" forState:UIControlStateNormal];
        [self.favourBtn setTitle:@"999+" forState:UIControlStateHighlighted];
    } else {
        [self.favourBtn setTitle:[NSString stringWithFormat:@"%ld",(long)comment.goodNums] forState:UIControlStateNormal];
        [self.favourBtn setTitle:[NSString stringWithFormat:@"%ld",(long)comment.goodNums] forState:UIControlStateHighlighted];
    }
    
}

- (IBAction)favourPressed:(id)sender {
    if (self.favourBlcok) {
        self.favourBlcok(sender);
    }
}

@end
