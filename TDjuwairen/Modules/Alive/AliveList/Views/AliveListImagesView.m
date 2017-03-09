//
//  AliveListImagesView.m
//  TDjuwairen
//
//  Created by zdy on 2017/3/9.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveListImagesView.h"
#import "UIImageView+WebCache.h"

@implementation AliveListImagesView

- (void)setImages:(NSArray *)images {
    _images = images;
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat height = 0.f;
    
    if (images.count == 1) {
        UIImageView *one = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 180, 180)];
        one.contentMode = UIViewContentModeScaleAspectFit;
        [one sd_setImageWithURL:[NSURL URLWithString:images.firstObject] placeholderImage:nil];
        [self addSubview:one];
        
        height = 180.0f;
    } else if (images.count > 1)  {
        int x =0,y =0,i =0;
        
        for (NSString *imageUrl in images) {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.frame = CGRectMake((80+10)*x, (80+10)*y, 80, 80);
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
            [self addSubview:imageView];
            
            x = i/3;
            y = i%3;
            i++;
        }
        
        height = 80*x + (((x-1)>0)?((x-1)*10):0);
    }
    
//    CGRect rect = self.bounds;
//    rect.size.height = height;
//    self.bounds = rect;
}



@end
