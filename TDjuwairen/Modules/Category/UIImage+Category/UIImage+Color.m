//
//  UIImage+Color.m
//  baiwandian
//
//  Created by zdy on 15/10/10.
//  Copyright © 2015年 xinyunlian. All rights reserved.
//

#import "UIImage+Color.h"

@implementation UIImage (Color)

+ (UIImage *)imageWithSize:(CGSize)size withColor:(UIColor *)color withBackgroundColor:(UIColor *)backgroudColor withCornerWidth:(CGFloat)cornerWidth
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, backgroudColor.CGColor);
    CGContextFillRect(context, rect);

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGPathRef path = CGPathCreateWithRoundedRect(rect, cornerWidth, cornerWidth, nil);
    CGContextAddPath(context, path);
    
    CGContextDrawPath(context, kCGPathFill);
    CGPathRelease(path);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

+ (UIImage *)imageWithSize:(CGSize)size withColor:(UIColor *)color withCornerWidth:(CGFloat)cornerWidth
{
    return [UIImage imageWithSize:size withColor:color withBackgroundColor:[UIColor whiteColor] withCornerWidth:cornerWidth];
}

+ (UIImage *)imageWithSize:(CGSize)size withColor:(UIColor *)color
{
    return [UIImage imageWithSize:size withColor:color withCornerWidth:0];
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    return [UIImage imageWithSize:CGSizeMake(4, 4) withColor:color];
}
@end
