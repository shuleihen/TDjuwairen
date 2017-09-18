//
//  AliveListViewpointTableViewCell.m
//  TDjuwairen
//
//  Created by zdy on 2017/9/17.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveListViewpointTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation AliveListViewpointTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.avatar.layer.cornerRadius = 10.0f;
    self.avatar.clipsToBounds = YES;
    
    self.originalLabel.layer.cornerRadius = 2.0f;
    self.originalLabel.layer.borderWidth = TDPixel;
    self.originalLabel.layer.borderColor = [UIColor hx_colorWithHexRGBAString:@"#0E2D67"].CGColor;
    
}

- (void)setupAliveModel:(AliveListModel *)model {
    
    self.titleLabel.text = model.aliveTitle;
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:model.masterAvatar] placeholderImage:TDDefaultUserAvatar];
    self.nickNameLabel.text = model.masterNickName;
    self.timeLabel.text = model.aliveTime;
    
    if ([model.extra isKindOfClass:[NSDictionary class]]) {
        NSString *desc = model.extra[@"view_desc"];
        self.contentLabel.text = desc;
    }
    
    if (model.aliveImgs.count) {
        [self.cover sd_setImageWithURL:[NSURL URLWithString:model.aliveImgs.firstObject] placeholderImage:nil];
        self.converWidth.constant = 105;
    } else {
        self.converWidth.constant = 0.0f;
    }
    
    NSString *readNum = [NSString stringWithFormat:@"评论%ld • 阅读%ld",model.commentNum,model.visitNum];
    self.readNumLabel.text = readNum;
}

@end
