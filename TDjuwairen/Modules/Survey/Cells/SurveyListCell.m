//
//  SurveyListCell.m
//  TDjuwairen
//
//  Created by zdy on 16/10/11.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "SurveyListCell.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Resize.h"

@implementation SurveyListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.userAvatar.layer.cornerRadius = 25.0/2;
    self.userAvatar.clipsToBounds = YES;
    self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    self.thumbImageView.frame = CGRectMake(kScreenWidth-8-90, 55, 90, 90);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateConstraints {
    [super updateConstraints];
}

+ (CGFloat)heightWithModel:(SurveyListModel *)model {
    CGSize titleSize = [model.sharp_title boundingRectWithSize:CGSizeMake(kScreenWidth - 15 - 8 - 90 -8, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:18]} context:nil].size;
//    CGSize detailSize = [model.sharp_desc boundingRectWithSize:CGSizeMake(kScreenWidth - 15 - 8 - 90 -8, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    
    return 55+titleSize.height + 10 + 55 +15;
}

- (void)setupSurveyListModel:(SurveyListModel *)model {
    [self.userAvatar sd_setImageWithURL:[NSURL URLWithString:model.user_facemin]];
    self.nameLabel.text = [NSString stringWithFormat:@"%@ · %@",model.user_nickname,model.sharp_wtime];
    
    self.titleLabel.text = model.sharp_title;
    self.detailLabel.text = model.sharp_desc;

    [self.thumbImageView sd_setImageWithURL:[NSURL URLWithString:model.sharp_imgurl] placeholderImage:nil options:SDWebImageCacheMemoryOnly completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
        NSString *key = [SDWebImageManager.sharedManager cacheKeyForURL:imageURL];
        
        if ([SDWebImageManager.sharedManager.imageCache diskImageExistsWithKey:key]) {
//            NSLog(@"Img key = %@ already save in disk",key);
            self.userAvatar.image = image;
        } else {
//            NSLog(@"Img key = %@ resize to 90*90 and save to disk",key);
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImage *img = [image resize:CGSizeMake(90, 90)];
                NSString *key = [SDWebImageManager.sharedManager cacheKeyForURL:imageURL];
                [SDWebImageManager.sharedManager.imageCache storeImage:img forKey:key];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.userAvatar.image = img;
                });
            });
        }
    }];

    CGSize titleSize = [model.sharp_title boundingRectWithSize:CGSizeMake(kScreenWidth - 15 - 8 - 90 -8, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:18]} context:nil].size;
//    CGSize detailSize = [model.sharp_desc boundingRectWithSize:CGSizeMake(kScreenWidth - 15 - 8 - 90 -8, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    
    self.titleLabel.frame = CGRectMake(15, 55, kScreenWidth - 15 - 8 - 90 -8, titleSize.height);
    self.detailLabel.frame = CGRectMake(15, 55 + titleSize.height +10, kScreenWidth - 15 - 8 - 90 -8, 55);
}
@end
