//
//  AliveVideoListTableViewCell.m
//  TDjuwairen
//
//  Created by zdy on 2017/6/1.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveVideoListTableViewCell.h"
#import "HexColors.h"
#import "UIImageView+WebCache.h"

@implementation AliveVideoListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.stockNameLabel.layer.borderWidth = 1.0f;
    self.stockNameLabel.layer.borderColor = [UIColor hx_colorWithHexRGBAString:@"#3371E2"].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)heightWithAliveModel:(AliveListModel *)model {
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:model.aliveTitle attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0f], NSForegroundColorAttributeName : [UIColor hx_colorWithHexRGBAString:@"#333333"]}];
    
    NSTextAttachment *attatch = [[NSTextAttachment alloc] initWithData:nil ofType:nil];
    attatch.bounds = CGRectMake(2, -2, 17, 17);
    attatch.image = [UIImage imageNamed:@"type_video.png"];
    
    NSAttributedString *video = [NSAttributedString attributedStringWithAttachment:attatch];
    [attri appendAttributedString:video];

    CGSize size = [attri boundingRectWithSize:CGSizeMake(kScreenWidth-24, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    
    return size.height + 280;
}

- (void)setupAliveModel:(AliveListModel *)model {
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:model.aliveTitle attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0f], NSForegroundColorAttributeName : [UIColor hx_colorWithHexRGBAString:@"#333333"]}];
    
    UIImage *image = [self imageWithAliveType:model.aliveType];
    if (image) {
        NSTextAttachment *attatch = [[NSTextAttachment alloc] initWithData:nil ofType:nil];
        attatch.bounds = CGRectMake(2, -2, 17, 17);
        attatch.image = image;
        
        NSAttributedString *video = [NSAttributedString attributedStringWithAttachment:attatch];
        [attri appendAttributedString:video];
    }
    
    if (!model.extra.isUnlock) {
        NSTextAttachment *attatch = [[NSTextAttachment alloc] initWithData:nil ofType:nil];
        attatch.bounds = CGRectMake(5, 0, 10, 12);
        attatch.image = [UIImage imageNamed:@"ico_lock.png"];
        
        NSAttributedString *lock = [NSAttributedString attributedStringWithAttachment:attatch];
        [attri appendAttributedString:lock];
    }
    
    CGSize size = [attri boundingRectWithSize:CGSizeMake(kScreenWidth-24, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    
    self.titleHeight.constant = size.height+2;
    self.titleLabel.attributedText = attri;
    
    [self.urlImageView sd_setImageWithURL:[NSURL URLWithString:model.aliveImgs.firstObject] placeholderImage:nil];
    
    NSString *stock = [NSString stringWithFormat:@"%@(%@)",model.extra.companyName,model.extra.companyCode];
    CGSize stockSize = [stock boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.0f]} context:nil].size;
    self.stockNameWidth.constant = stockSize.width+2;
    self.stockNameLabel.text = stock;
    
    self.dateTimeLabel.text = model.aliveTime;
    
    self.videoImageView.hidden = !(model.aliveType == kAliveVideo);
}

- (UIImage *)imageWithAliveType:(NSInteger)type {
    UIImage *image;
    
    switch (type) {
        case kAliveSurvey:
            // 调研
            image = [UIImage imageNamed:@"type_shi.png"];
            break;
        case kAliveHot:
            // 热点
            image = [UIImage imageNamed:@"type_talk.png"];
            break;
//        case 5:
//            // 深度
//            image = [UIImage imageNamed:@"type_deep.png"];
//            break;
//        case 6:
//            // 评论
//            image = [UIImage imageNamed:@"type_discuss.png"];
//            break;
        case kAliveVideo:
            // 视频
            image = [UIImage imageNamed:@"type_video.png"];
            break;
        default:
            break;
    }
    
    return image;
}
@end
