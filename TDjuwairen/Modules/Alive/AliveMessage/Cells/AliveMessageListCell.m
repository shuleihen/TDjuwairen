//
//  AliveMessageListCell.m
//  TDjuwairen
//
//  Created by zdy on 2017/3/13.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveMessageListCell.h"
#import "UIImageView+WebCache.h"

@implementation AliveMessageListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.avatarImageView.layer.cornerRadius = 20;
    self.avatarImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupMessageModel:(AliveMessageModel *)message {
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:message.avatar] placeholderImage:[UIImage imageNamed:@""]];
    self.nickNameLabel.text = message.nickName;
    self.timeLabel.text = message.time;
    
    if (message.messageType == kMessageTypeAliveNormalComment ||
        message.messageType == kMessageTypeAlivePostsComment) {
        // 评论
        self.messageLabel.text = message.messageContent;
        
     } else if (message.messageType == kMessageTypeAliveNormalLike ||
               message.messageType == kMessageTypeAlivePostsLike) {
        // 点赞
        NSTextAttachment *attatch = [[NSTextAttachment alloc] initWithData:nil ofType:nil];
        attatch.bounds = CGRectMake(0, -4, 19, 22);
        attatch.image = [UIImage imageNamed:@"alive_zan.png"];
        
        NSAttributedString *wait = [NSAttributedString attributedStringWithAttachment:attatch];
        self.messageLabel.attributedText = wait;
        
    } else if (message.messageType == kMessageTypeAliveNormalShare ||
               message.messageType == kMessageTypeAlivePostsShare) {
        // 分享
        NSTextAttachment *attatch = [[NSTextAttachment alloc] initWithData:nil ofType:nil];
        attatch.bounds = CGRectMake(0, -4, 19, 22);
        attatch.image = [UIImage imageNamed:@"alive_share.png"];
        
        NSAttributedString *wait = [NSAttributedString attributedStringWithAttachment:attatch];
        self.messageLabel.attributedText = wait;
    }
    
    if (message.aliveContentType == kAliveContentTxt) {
        // 文本
        self.aliveImageView.hidden = YES;
        self.aliveContentLabel.hidden = NO;
        
        self.aliveContentLabel.text = message.aliveContent;
    } else {
        self.aliveImageView.hidden = NO;
        self.aliveContentLabel.hidden = YES;
        
        [self.aliveImageView sd_setImageWithURL:[NSURL URLWithString:message.aliveContent] placeholderImage:nil];
    }
}
@end
