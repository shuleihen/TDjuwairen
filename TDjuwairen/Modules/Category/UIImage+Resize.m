//
//  UIImage+Resize.m
//  TDjuwairen
//
//  Created by zdy on 16/10/12.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "UIImage+Resize.h"

@implementation UIImage (Resize)
- (UIImage *)resize:(CGSize)size {
    UIImage *image = self;

    UIGraphicsBeginImageContextWithOptions(size, YES, [UIScreen mainScreen].scale);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
