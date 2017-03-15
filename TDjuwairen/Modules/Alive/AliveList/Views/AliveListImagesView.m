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
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat height = 0.f;
    
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
        
        height = 180.0f;
    } else if (images.count > 1)  {
        int x =0,y =0,i =0;
        
        
        for (NSString *imageUrl in images) {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.userInteractionEnabled = YES;
            imageView.tag = i;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDetailImageView:)];
            [imageView addGestureRecognizer:tap];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            [self.imageViews addObject:imageView];
            imageView.frame = CGRectMake((80+10)*x, (80+10)*y, 80, 80);
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
            [self addSubview:imageView];
            
            x = (i+1)%3;
            y = (i+1)/3;
            i++;
        }
        
        height = 80*x + (((x-1)>0)?((x-1)*10):0);
    }
    
//    CGRect rect = self.bounds;
//    rect.size.height = height;
//    self.bounds = rect;
}


- (void)showDetailImageView:(UITapGestureRecognizer *)tap {

//    UIImageView *currentImageView = (UIImageView *)tap.view;
    NSInteger index = tap.view.tag==nil?0:tap.view.tag;
    MYPhotoBrowser *photoBrowser = [[MYPhotoBrowser alloc]initWithUrls:self.images imgViews:self.imageViews placeholder:nil currentIdx:index handleNames:nil callback:^(UIImage *handleImage,NSString *handleType) {
        
        NSLog(@"-------------图片对象-%@----操作类型-%ld",handleImage,(long)handleType);
        
    }];
    [photoBrowser showWithAnimation:YES];


}


@end
