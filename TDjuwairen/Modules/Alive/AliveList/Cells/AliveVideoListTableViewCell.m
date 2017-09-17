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
#import "SurveyHandler.h"

@implementation AliveVideoListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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
    AliveListExtra *extra = model.extra;
    
    UIImage *image = [SurveyHandler imageWithSurveyType:extra.surveyType];
    if (image) {
        NSTextAttachment *attatch = [[NSTextAttachment alloc] initWithData:nil ofType:nil];
        attatch.bounds = CGRectMake(2, -2, 17, 17);
        attatch.image = image;
        
        NSAttributedString *video = [NSAttributedString attributedStringWithAttachment:attatch];
        [attri appendAttributedString:video];
    }
    
    if (!extra.isUnlock) {
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
    
    if (model.aliveType == kAliveDeep) {
        // 深度
        self.stockNameLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#FE8E3A"];
        self.stockNameLabel.text = extra.deepPayTip;
    } else {
        self.stockNameLabel.textColor = TDThemeColor;
        NSString *stock = [NSString stringWithFormat:@"%@(%@)",extra.companyName,extra.companyCode];
        self.stockNameLabel.text = stock;
    }
    
    self.dateTimeLabel.text = model.aliveTime;
    
    self.videoImageView.hidden = !(model.aliveType == kAliveVideo);
}

@end
