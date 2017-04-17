//
//  AliveListImagesView.m
//  TDjuwairen
//
//  Created by zdy on 2017/3/9.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveListImagesView.h"
#import "UIImageView+WebCache.h"
#import "MYPhotoBrowser.h"

@implementation AliveListImagesView

- (NSMutableArray *)imageViews
{
    if (!_imageViews) {
        _imageViews = [NSMutableArray array];
    }
    return _imageViews;
}

- (void)setImages:(NSArray *)images {
    _images = images;
    
//    self.backgroundColor = [UIColor blueColor];
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.imageViews removeAllObjects];
    
    
    if (images.count == 1) {
        UIImageView *one = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 180, 180)];
        one.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDetailImageView:)];
        one.tag = 0;
        [one addGestureRecognizer:tap];
        [self.imageViews addObject:one];
        one.contentMode = UIViewContentModeScaleAspectFit;
        [one sd_setImageWithURL:[NSURL URLWithString:images.firstObject] placeholderImage:nil];
        [self addSubview:one];
        
    } else if (images.count > 1)  {
        int x =0,y =0,i =0;
        
        
        for (NSString *imageUrl in images) {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.userInteractionEnabled = YES;
            imageView.frame = CGRectMake((80+5)*x, (80+5)*y, 80, 80);
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            [self.imageViews addObject:imageView];
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
            [self addSubview:imageView];
            
            imageView.tag = i;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDetailImageView:)];
            [imageView addGestureRecognizer:tap];
            
            x = (i+1)%3;
            y = (i+1)/3;
            i++;
        }
    }
    
}


- (void)showDetailImageView:(UITapGestureRecognizer *)tap {

    NSInteger index = tap.view.tag;
    if (index>= 0 && index<self.images.count) {
        MYPhotoBrowser *photoBrowser = [[MYPhotoBrowser alloc] initWithUrls:self.images imgViews:self.imageViews placeholder:nil currentIdx:index handleNames:nil callback:^(UIImage *handleImage,NSString *handleType) {
            
            NSLog(@"-------------图片对象-%@----操作类型-%ld",handleImage,(long)handleType);
            
        }];
        [photoBrowser showWithAnimation:YES];
    }
}


@end
