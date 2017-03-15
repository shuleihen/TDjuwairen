//
//  AskTableViewCell.m
//  TDjuwairen
//
//  Created by zdy on 2016/12/21.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "AskTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation AskTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.avatar.clipsToBounds = YES;
    self.avatar.layer.cornerRadius = 11.0f;
    self.contentLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#222222"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)heightWithContent:(NSString *)content {
    CGFloat height = 0;
    
    CGSize size =  [content boundingRectWithSize:CGSizeMake(kScreenWidth-47-15, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f]} context:nil].size;
    
    height = size.height + 81 + 15;
    return height;
}

- (void)setupAsk:(AskModel *)ask {
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:ask.userinfo_facemin] placeholderImage:TDDefaultUserAvatar];
    self.userNameLabel.text = ask.user_nickname;
    self.contentLabel.text = ask.surveyask_content;
    self.dateTimeLabel.text = ask.surveyask_addtime;
    self.askBtn.hidden = ask.is_author;
}

- (IBAction)askPressed:(id)sender {
    if (self.askBlcok) {
        self.askBlcok();
    }
}

@end
