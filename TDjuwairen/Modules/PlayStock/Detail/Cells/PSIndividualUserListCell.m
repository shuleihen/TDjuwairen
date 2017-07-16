//
//  PSIndividualUserListCell.m
//  TDjuwairen
//
//  Created by zdy on 2017/7/15.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "PSIndividualUserListCell.h"
#import "UIImageView+WebCache.h"

@implementation PSIndividualUserListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupUserModel:(PSIndividualUserListModel *)model {
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.userinfo_facemin] placeholderImage:TDDefaultUserAvatar];
    self.rateLabel.text = [NSString stringWithFormat:@"%ld",(long)model.rank];
    self.nickNameLabel.text = model.user_nickname;
    self.timeLabel.text = model.addTime;
    
    if (model.showItemPoints) {
        self.pointLabel.text = [NSString stringWithFormat:@"%.02f",model.item_points.floatValue];
    } else {
        self.pointLabel.text = @"--";
    }
    
    self.startBtn.hidden = !model.isStarter;
    
    if (model.is_winner) {
        NSString *winString = [NSString stringWithFormat:@"获得%ld把", (long)model.winKeyNum];
        CGSize size = [winString boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13.0f]} context:nil].size;
        self.winkeyViewHeight.constant = size.width+30+6;
        self.winKeyView.statusString = winString;
        self.winImageView.hidden = NO;
    } else {
        self.winkeyViewHeight.constant = 0;
        self.winKeyView.statusString = @"";
        self.winImageView.hidden = YES;
    }
}
@end
