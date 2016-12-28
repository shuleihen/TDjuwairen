//
//  PlayStockCommentCell.m
//  TDjuwairen
//
//  Created by zdy on 2016/12/26.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "GuessCommentCell.h"
#import "UIImageView+WebCache.h"

@implementation GuessCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.avatar.layer.cornerRadius = 20.0f;
    self.avatar.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (CGFloat)heightWithComment:(GuessCommentModel *)commtent {
    CGFloat height = 0.f;
    
    CGSize size = [commtent.content boundingRectWithSize:CGSizeMake(kScreenWidth-72, MAXFLOAT)
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f]} context:nil].size;
    
    
    return height;
}

- (void)setupGuessComment:(GuessCommentModel *)guessComment {
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:guessComment.userAvatar] placeholderImage:[UIImage imageNamed:@"photo_m.png"]];
    self.nameLabel.text = guessComment.userName;
    
}

- (IBAction)answerPressed:(id)sender {
}
@end
