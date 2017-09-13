//
//  UIImage+imageSize.m
//
//
//  Created by 孟遥 on 16/11/24.
//  Copyright © 2016年 mengyao. All rights reserved.
//

#import "UIImage+imageSize.h"
#import <ImageIO/ImageIO.h>
#import "UIImageView+WebCache.h"


@implementation UIImage (imageSize)

+ (void)getImageSizeWithURL:(id)imageURL backBlock:(void (^)(CGSize))block{
    NSURL * url = nil;
        if ([imageURL isKindOfClass:[NSURL class]]) {
            url = imageURL;
        }
        if ([imageURL isKindOfClass:[NSString class]]) {
            url = [NSURL URLWithString:imageURL];
        }
        if (!imageURL) {
            if (block) {
                block(CGSizeZero);
            }
           
        }
    UIImageView *v1 = [[UIImageView alloc]init];
    [v1 sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default1"]options:SDWebImageRetryFailed completed:^(UIImage *image,NSError *error,SDImageCacheType cacheType,NSURL *imageUrl){
        CGSize size = image.size;
        CGFloat w = size.width;
        CGFloat H = size.height;
        if (block) {
            block(CGSizeMake(w, H));
        }
        
    }];

}


@end
