//
//  AliveListStockPoolTableViewCell.m
//  TDjuwairen
//
//  Created by zdy on 2017/8/11.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveListStockPoolTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation AliveListStockPoolTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupAliveStockPool:(AliveListStockPoolModel *)stockPool {
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:stockPool.userAvatar] placeholderImage:TDDefaultUserAvatar];
    
    NSString *nick = [NSString stringWithFormat:@"%@的股票池",stockPool.userNickName];
    NSMutableAttributedString *nickAttri = [[NSMutableAttributedString alloc] initWithString:nick attributes:@{NSForegroundColorAttributeName:[UIColor hx_colorWithHexRGBAString:@"#151515"]}];
    [nickAttri setAttributes:@{NSForegroundColorAttributeName:TDThemeColor} range:NSMakeRange(0, stockPool.userNickName.length)];
    self.nickNameLabel.attributedText = nickAttri;
    
    self.contentLabel.text = stockPool.poolDesc?:@"暂无简介";
    
    NSString *subscribe = [NSString stringWithFormat:@"%ld人已订阅",(long)stockPool.subscribeNum];
    NSMutableAttributedString *subscribeAttri = [[NSMutableAttributedString alloc] initWithString:subscribe attributes:@{NSForegroundColorAttributeName:TDDetailTextColor}];
    [subscribeAttri setAttributes:@{NSForegroundColorAttributeName:TDThemeColor} range:NSMakeRange(0, subscribe.length-3)];
    self.subscriptionNumLabel.attributedText = subscribeAttri;
    
    if (stockPool.isFree) {
        self.subscribeLabel.hidden = YES;
        self.payInfoLabel.text = stockPool.poolSetTip;
        self.residueDayLabel.text = @"";
    } else {
        if (stockPool.isSubscribe && stockPool.isExpire) {
            self.subscribeLabel.hidden = NO;
            self.residueDayLabel.text = stockPool.poolSetTip;
            self.payInfoLabel.text = @"";
        } else {
            self.subscribeLabel.hidden = YES;
            self.residueDayLabel.text = @"";
            self.payInfoLabel.text = stockPool.poolSetTip;
        }
    }
    
}
@end
