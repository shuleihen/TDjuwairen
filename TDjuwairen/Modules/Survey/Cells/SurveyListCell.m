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
    self.titleLabel.preferredMaxLayoutWidth = kScreenWidth - 15 - 8 - 90 -8;
    self.detailLabel.preferredMaxLayoutWidth = kScreenWidth - 15 - 8 - 90 -8;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateConstraints {
    [super updateConstraints];
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

}
@end
