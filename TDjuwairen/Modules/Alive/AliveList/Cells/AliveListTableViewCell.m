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
    self.tiedanLabel.layer.borderColor = [UIColor hx_colorWithHexRGBAString:@"#cccccc"].CGColor;
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
    [self setupAliveModel:aliveModel isShowDetail:NO];
}

- (void)setupAliveModel:(AliveListModel *)aliveModel isShowDetail:(BOOL)isShowDetail{
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:aliveModel.masterAvatar] placeholderImage:TDDefaultUserAvatar];
    self.nickNameLabel.text = aliveModel.masterNickName;
    self.timeLabel.text = aliveModel.aliveTime;
    
    if (isShowDetail) {
        self.titleLabel.numberOfLines = 0;
    } else {
        self.titleLabel.numberOfLines = 3;
    }
    self.titleLabel.text = aliveModel.aliveTitle;
    
    self.imagesView.images = aliveModel.aliveImgs;
    self.imagesHeight.constant = [AliveListTableViewCell imagesViewHeightWithImages:aliveModel.aliveImgs];
    
    self.tiedanLabel.hidden = (aliveModel.aliveType ==2)?NO:YES;
}

+ (CGFloat)heightWithAliveModel:(AliveListModel *)aliveModel isShowDetail:(BOOL)isShowDetail {
    CGFloat height = 0.0f;
    
    height += 42.0f;
    
    if (isShowDetail) {
        // 文字全部显示
        CGSize size = [aliveModel.aliveTitle boundingRectWithSize:CGSizeMake(kScreenWidth-64-12, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f]} context:nil].size;
        height += size.height;
    } else {
        CGSize size = [aliveModel.aliveTitle boundingRectWithSize:CGSizeMake(kScreenWidth-64-12, 50) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f]} context:nil].size;
        height += size.height;
    }
    
    
    height += 8;
    
    height += [self imagesViewHeightWithImages:aliveModel.aliveImgs];
    
    height += 14.0f;
    
    return height;
}

+ (CGFloat)heightWithAliveModel:(AliveListModel *)aliveModel {
    return [self heightWithAliveModel:aliveModel isShowDetail:NO];
}

+ (CGFloat)imagesViewHeightWithImages:(NSArray *)images {
    CGFloat height = 0.f;
    if (images.count == 0) {
        height = 0;
    } else if (images.count == 1) {
        height = 180.0f;
    } else if (images.count > 1) {
        NSInteger x = images.count/3;
        NSInteger y = images.count%3;
        if (y > 0) {
            x++;
        }
        height = 80*x+(((x-1)>0)?((x-1)*10):0);
    }
    
    return height;
}
@end
