//
//  PublishForwardTableViewCell.m
//  TDjuwairen
//
//  Created by zdy on 2017/9/6.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "PublishForwardTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "AliveTypeDefine.h"

@implementation PublishForwardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupPublishModel:(AlivePublishModel *)model withPublishType:(NSInteger)publishType {
    [self.forwardImageView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:TDDefaultAppIcon];
    NSMutableAttributedString *attr;
    if (publishType == kAlivePublishForward) {
        NSString *title = [NSString stringWithFormat:@"@%@", model.masterNickName];
        attr = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:TDThemeColor}];
        self.titleLabel.attributedText = attr;
        self.descLabel.text = model.detail;
    } else if (publishType == kAlivePublishVisitCard) {
        NSString *title = [NSString stringWithFormat:@"@%@的个人主页", model.masterNickName];
        attr = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:TDThemeColor}];
        [attr setAttributes:@{NSForegroundColorAttributeName:TDTitleTextColor} range:NSMakeRange(model.masterNickName.length+1, title.length-model.masterNickName.length-1)];
        self.titleLabel.attributedText = attr;
        self.descLabel.text = model.detail;
    } else if (publishType == kAlivePublishStockPool) {
        NSString *title = [NSString stringWithFormat:@"@%@的股票池", model.masterNickName];
        attr = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:TDThemeColor}];
        [attr setAttributes:@{NSForegroundColorAttributeName:TDTitleTextColor} range:NSMakeRange(model.masterNickName.length+1, title.length-model.masterNickName.length-1)];
        self.titleLabel.attributedText = attr;
        self.descLabel.text = model.detail;
    } else if (publishType == kAlivePublishSurvey ||
               publishType == kAlivePublishHot ||
               publishType == kAlivePublishDeep) {
        NSString *title = [NSString stringWithFormat:@"@%@", model.masterNickName];
        attr = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:TDThemeColor}];
        self.titleLabel.attributedText = attr;
        self.descLabel.text = model.title;
    } else {
        self.titleLabel.text = model.title;
        self.descLabel.text = model.detail;
    }
}
@end
