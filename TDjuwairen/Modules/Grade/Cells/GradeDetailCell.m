//
//  GradeDetailCell.m
//  TDjuwairen
//
//  Created by zdy on 2017/1/16.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "GradeDetailCell.h"
#import "UIImageView+WebCache.h"

@implementation GradeDetailCell

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

+ (CGFloat)heightWithContent:(NSString *)content {
    CGFloat height = 0;
    
    height = [content boundingRectWithSize:CGSizeMake(kScreenWidth-62-12, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0f]} context:nil].size.height + 39+31+12;

    return height;
}

+ (CGFloat)heightWithCommentModel:(GradeCommentModel *)model {
    CGFloat height = 0;
    
    CGFloat contentHeight = [model.content boundingRectWithSize:CGSizeMake(kScreenWidth-62-12, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0f]} context:nil].size.height;
    
    CGFloat replyViewHeight = [GradeCommReplyView heightWithReplyList:model.replyList withWidth:kScreenWidth-62-12];
    
    if (model.replyList.count) {
        height = 63 + contentHeight + 10 +replyViewHeight+ 36;
    } else {
        height = 63 + contentHeight + 36;
    }
    
    return height;
}

- (void)setupCommentModel:(GradeCommentModel *)model {
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"photo_m.png"]];
    self.userNameLabel.text = model.userName;
    self.contentLabel.text = model.content;
    self.dateTimeLabel.text = model.createTime;
    self.gradeLabel.text = [NSString stringWithFormat:@"%@分",model.grade];
    self.stockGodLabel.text = [NSString stringWithFormat:@"股神指数：%@",model.guessRate];
    
    self.replyViewHeight.constant = [GradeCommReplyView heightWithReplyList:model.replyList withWidth:kScreenWidth-62-12];
    self.replyView.replyList = model.replyList;
}

@end
