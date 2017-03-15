//
//  AliveListTableViewCell.m
//  TDjuwairen
//
//  Created by zdy on 2017/3/9.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveListTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "HexColors.h"

@implementation AliveListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.avatar.layer.cornerRadius = 20.0f;
    self.avatar.clipsToBounds = YES;
    
    self.tiedanLabel.layer.borderWidth = 0.5f;
    self.tiedanLabel.layer.borderColor = [UIColor hx_colorWithHexRGBAString:@"#999999"].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)avatarPressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(aliveListTableCell:avatarPressed:)]) {
        [self.delegate aliveListTableCell:self avatarPressed:sender];
    }
}


- (void)setupAliveModel:(AliveListModel *)aliveModel {
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:aliveModel.masterAvatar] placeholderImage:TDDefaultUserAvatar];
    self.nickNameLabel.text = aliveModel.masterNickName;
    self.timeLabel.text = aliveModel.aliveTime;
    
    self.titleLabel.text = aliveModel.aliveTitle;
    
    self.imagesView.images = aliveModel.aliveImgs;
    self.imagesHeight.constant = [AliveListTableViewCell imagesViewHeightWithImages:aliveModel.aliveImgs];
    
    self.tiedanLabel.hidden = (aliveModel.aliveType ==2)?NO:YES;
}

+ (CGFloat)heightWithAliveModel:(AliveListModel *)aliveModel {
    CGFloat height = 0.f;
    
    height += 42.0f;
    
    // 3行文字高50
    CGSize size = [aliveModel.aliveTitle boundingRectWithSize:CGSizeMake(kScreenWidth-64-12, 50) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f]} context:nil].size;
    height += size.height;
    
    height += 8;
    
    height += [self imagesViewHeightWithImages:aliveModel.aliveImgs];
    
    height += 14.0f;
    
    return height;
}

+ (CGFloat)imagesViewHeightWithImages:(NSArray *)images {
    CGFloat height = 0.f;
    if (images.count == 0) {
        height = 0;
    } else if (images.count == 1) {
        height = 180.0f;
    } else if (images.count > 1) {
        NSInteger x = images.count/3;
        height = 80*x + (((x-1)>0)?((x-1)*10):0);
    }
    
    return height;
}
@end
