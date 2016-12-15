//
//  CommentsTableViewCell.m
//  TDjuwairen
//
//  Created by tuanda on 16/6/2.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "CommentsTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIdaynightModel.h"

@interface CommentsTableViewCell ()

@property (nonatomic,strong) UIdaynightModel *daynightmodel;
@end
@implementation CommentsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.daynightmodel = [UIdaynightModel sharedInstance];
    self.line.layer.borderColor = self.daynightmodel.backColor.CGColor;
    self.line.layer.borderWidth = 0.5;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)setCellWithDic:(CommentManagerModel *)model
{
    NSString *head = model.userinfo_facemin;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:head] placeholderImage:nil];
    
    self.nicknameLabel.text = model.user_nickname;
    self.timeLabel.text = model.surveycomment_addtime ;
    self.commentsLabel.text = model.surveycomment_comment;
    
    NSString *sharp = model.survey_cover;
    [self.sharpImageView sd_setImageWithURL:[NSURL URLWithString:sharp] placeholderImage:nil];
    
    self.titleLabel.text=model.survey_title;
    
    self.nicknameLabel.textColor = self.daynightmodel.textColor;
    self.timeLabel.textColor = self.daynightmodel.textColor;
    self.commentsLabel.textColor = self.daynightmodel.textColor;
    self.titleLabel.textColor = self.daynightmodel.textColor;
    self.backView.backgroundColor = self.daynightmodel.backColor;
    self.backgroundColor = self.daynightmodel.navigationColor;
    
}


@end
