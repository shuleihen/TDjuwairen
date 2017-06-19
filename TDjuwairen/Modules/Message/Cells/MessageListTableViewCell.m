//
//  AliveMessageListCell.m
//  TDjuwairen
//
//  Created by zdy on 2017/3/13.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "MessageListTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation MessageListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.typeLabel.layer.borderColor = TDAssistTextColor.CGColor;
    self.typeLabel.layer.borderWidth = TDPixel;
    self.typeLabel.textColor = TDAssistTextColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupMessageModel:(MessageListModel *)message {
    
    if ([message.userAvatar isKindOfClass:[NSString class]]) {
        NSURL *url = [NSURL URLWithString:message.userAvatar];
        [self.avatarImageView sd_setImageWithURL:url placeholderImage:TDDefaultUserAvatar];
    } else {
        self.avatarImageView.image = TDDefaultUserAvatar;
    }
    
    self.nickNameLabel.text = message.userNickName;
    self.timeLabel.text = message.dateTime;
    
    
    switch (message.msgType) {
        case kMessageTypeSurveyPublish:
        case kMessageTypeSurveyAsk:
        case kMessageTypeTopicPublish:
        case kMessageTypePostPublish:
        case kMessageTypeViewpointPublish:
        case kMessageTypeAliveComment:
        case kMessageTypeAliveReply:
        case kMessageTypeVideoPublish:
        case kMessageTypeViewpointComment:
        case kMessageTypePlayStock:
        case kMessageTypeIndividualStock: {
            
            self.messageLabel.text = message.msgContent;
        }
            break;
        case kMessageTypeTopicLike:
        case kMessageTypePostLike:
        case kMessageTypeViewpointLike:{
            // 点赞
            NSTextAttachment *attatch = [[NSTextAttachment alloc] initWithData:nil ofType:nil];
            attatch.bounds = CGRectMake(0, -4, 19, 22);
            attatch.image = [UIImage imageNamed:@"alive_zan.png"];
            
            NSAttributedString *wait = [NSAttributedString attributedStringWithAttachment:attatch];
            self.messageLabel.attributedText = wait;
        }
            break;
        case kMessageTypeForward:{
            NSString *string = [NSString stringWithFormat:@"转发：%@",message.msgContent];
            NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:string];
            [attri addAttributes:@{NSForegroundColorAttributeName:TDThemeColor} range:NSMakeRange(0, 3)];
            self.messageLabel.attributedText = attri;
        }
            break;
        case kMessageTypeFans:{
            
        }
            break;
        default:
            break;
    }
    
    switch (message.msgType) {
        case kMessageTypeSurveyPublish:
        case kMessageTypeSurveyAsk:
        case kMessageTypeSurveyAns: {
            self.typeLabel.text = @"调研";
        }
            break;
        case kMessageTypeGradeReply:{
            self.typeLabel.text = @"评分";
        }
            break;
        case kMessageTypeTopicPublish:
        case kMessageTypeTopicLike:
        case kMessageTypeAliveReply:
        case kMessageTypeAliveComment:{
            self.typeLabel.text = @"话题";
        }
            break;
        case kMessageTypePostPublish:
        case kMessageTypePostLike:{
            self.typeLabel.text = @"贴单";
        }
            break;
        case kMessageTypeViewpointPublish:
        case kMessageTypeViewpointComment:
        case kMessageTypeViewpointReply:
        case kMessageTypeViewpointLike:{
            self.typeLabel.text = @"观点";
        }
            break;
        case kMessageTypePlayStock:
        case kMessageTypeIndividualStock:{
            self.typeLabel.text = @"玩票";
        }
            break;
        default:
            break;
    }
    
    if (message.rightType == 0) {
        // 文本
        self.aliveImageView.hidden = YES;
        self.aliveContentLabel.hidden = NO;
        
        self.aliveContentLabel.text = message.rightContent;
    } else {
        self.aliveImageView.hidden = NO;
        self.aliveContentLabel.hidden = YES;
        
        [self.aliveImageView sd_setImageWithURL:[NSURL URLWithString:message.rightContent] placeholderImage:nil];
    }
    
       /*
    if (message.msgType == kMessageTypeAliveNormalComment ||
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
    */
    /*
    if (message.aliveContentType == kAliveContentTxt) {
        // 文本
        self.aliveImageView.hidden = YES;
        self.aliveContentLabel.hidden = NO;
        
        self.aliveContentLabel.text = message.aliveContent;
    } else {
        self.aliveImageView.hidden = NO;
        self.aliveContentLabel.hidden = YES;
        
        [self.aliveImageView sd_setImageWithURL:[NSURL URLWithString:message.aliveContent] placeholderImage:nil];
    }*/
    
}
@end
