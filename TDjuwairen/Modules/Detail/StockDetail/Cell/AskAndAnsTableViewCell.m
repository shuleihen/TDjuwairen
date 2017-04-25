//
//  AskAndAnsTableViewCell.m
//  TDjuwairen
//
//  Created by zdy on 2017/4/25.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AskAndAnsTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "AnsModel.h"
#import "NetworkManager.h"
#import "UIButton+LikeAnimation.h"

@implementation AskAndAnsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.askAvatar.layer.cornerRadius = 20.0f;
    self.askAvatar.clipsToBounds = YES;
    
    self.ansView.layer.cornerRadius = 4.0f;
    self.ansView.clipsToBounds = YES;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)cellHeightWithSurveyAskModel:(AskModel *)model {
    CGFloat height = 0.0f;
    
    CGFloat contentHeight = [model.askContent boundingRectWithSize:CGSizeMake(kScreenWidth-62-12, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0f]} context:nil].size.height;
    
    CGFloat replyViewHeight = [SurveyAnsView heightWithAnsList:model.ansList withWidth:kScreenWidth-62-12];
    
    if (model.ansList.count) {
        height = 45 + contentHeight + 10 +replyViewHeight+ 40;
    } else {
        height = 45 + contentHeight + 40;
    }
    
    return height;
}

- (void)setupAskModel:(AskModel *)model {
    self.askModel = model;
    
    [self.askAvatar sd_setImageWithURL:[NSURL URLWithString:model.askUserAvatar] placeholderImage:[UIImage imageNamed:@"photo_m.png"]];
    self.askUserNameLabel.text = model.askUserName;
    self.askCommentLable.text = model.askContent;
    self.addTimeLabel.text = model.askAddTime;
   
    self.ansViewHeight.constant = [SurveyAnsView heightWithAnsList:model.ansList withWidth:kScreenWidth-62-12];
    self.ansView.ansList = model.ansList;
    
    if (model.ansList.count) {
        AnsModel *ans = model.ansList.firstObject;
         [self.likeBtn setTitle:[NSString stringWithFormat:@"%ld",(long)ans.ansLikeNum] forState:UIControlStateNormal];
        self.likeBtn.selected = ans.isLiked;
    }
}

- (IBAction)likePressed:(id)sender {
    NetworkManager *manager = [[NetworkManager alloc] init];
    AnsModel *model = self.askModel.ansList.firstObject;
    if (!model) {
        return;
    }
    
    NSDictionary *dict = @{@"answer_id": model.answerId};
    __weak AskAndAnsTableViewCell *wself = self;
    
    UIButton *btn = sender;
    if (btn.selected) {
        [manager POST:API_SurveyAskUnLike parameters:dict completion:^(id data, NSError *error) {
            
            if (!error) {
                model.ansLikeNum--;
                model.isLiked = NO;
                
                [wself.likeBtn setTitle:[NSString stringWithFormat:@"%ld",(long)model.ansLikeNum] forState:UIControlStateNormal];
                wself.likeBtn.selected = NO;
                [wself.likeBtn addLikeAnimation];
            }else{
                MBAlert(@"用户已取消点赞")
            }
        }];
    }else{
        [manager POST:API_SurveyAskLike parameters:dict completion:^(id data, NSError *error) {
            
            if (!error) {
                model.ansLikeNum++;
                model.isLiked = YES;

                [wself.likeBtn setTitle:[NSString stringWithFormat:@"%ld",(long)model.ansLikeNum] forState:UIControlStateNormal];
                wself.likeBtn.selected = YES;
                [wself.likeBtn addLikeAnimation];
            }else{
                MBAlert(@"用户已点赞")
            }
        }];
    }
}

@end
