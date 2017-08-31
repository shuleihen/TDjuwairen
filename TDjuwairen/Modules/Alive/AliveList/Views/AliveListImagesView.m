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
#import "NSString+ImageSize.h"

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
    [self.imageViews removeAllObjects];
    
    
    if (images.count == 1) {
        CGSize size = [images.firstObject imageSize];
        CGFloat w =180,h=180;
        if (!CGSizeEqualToSize(size, CGSizeZero)) {
            if (size.width > size.height) {
                w = kScreenWidth/2;
                h = (size.height/size.width)*w;
            } else if (size.height > size.width) {
                h = kScreenWidth/2;
                w = (size.width/size.height)*h;
            }
        }
        
        UIImageView *one = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
        one.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDetailImageView:)];
        one.tag = 0;
        [one addGestureRecognizer:tap];
        [self.imageViews addObject:one];
        one.contentMode = UIViewContentModeScaleAspectFit;
        one.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#eeeeee"];
        
        [one sd_setImageWithURL:[NSURL URLWithString:images.firstObject] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
            one.backgroundColor = [UIColor clearColor];
        }];
        [self addSubview:one];
        
    } else if (images.count > 1)  {
        int x =0,y =0,i =0;
        
        CGFloat space = 5.0f;
        CGFloat border = 12.0f;
        CGFloat itemW = (kScreenWidth-border*2-space*2)/3;
        
        int lineCount;
        if (images.count == 4) {
            lineCount = 2;
        } else {
            lineCount = 3;
        }
        
        for (NSString *imageUrl in images) {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.userInteractionEnabled = YES;
            imageView.frame = CGRectMake((itemW+space)*x, (itemW+space)*y, itemW, itemW);
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            [self.imageViews addObject:imageView];
            
            imageView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#eeeeee"];
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
                imageView.backgroundColor = [UIColor clearColor];
            }];
            
            [self addSubview:imageView];
            
            imageView.tag = i;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDetailImageView:)];
            [imageView addGestureRecognizer:tap];
            
            x = (i+1)%lineCount;
            y = (i+1)/lineCount;
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
