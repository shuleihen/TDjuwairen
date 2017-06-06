//
//  AnsTableViewCell.m
//  TDjuwairen
//
//  Created by zdy on 2016/12/21.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "AnsTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation AnsTableViewCell

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

+ (CGFloat)heightWithContent:(NSString *)content isFirst:(BOOL)isFirst {
    CGFloat height = 0;
    
    CGSize size =  [content boundingRectWithSize:CGSizeMake(kScreenWidth-47-15, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f]} context:nil].size;
    if (isFirst) {
        height = size.height + 59 + 15;
    } else {
        height = size.height + 89 + 15;
    }
    
    return height;
}

- (void)setupAns:(AnsModel *)ans {
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:ans.ansUserAvatar]];
    self.userNameLabel.text = ans.ansUserName;
//    self.dateTimeLabel.text = ans.;
    self.contentLabel.text = ans.ansContent;
}
@end
