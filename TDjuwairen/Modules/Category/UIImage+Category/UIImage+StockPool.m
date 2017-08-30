//
//  UIImage+StockPool.m
//  TDjuwairen
//
//  Created by zdy on 2017/8/10.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "UIImage+StockPool.h"

@implementation UIImage (StockPool)
+ (UIImage *)imageWithStockPoolListLeft {
    UIImage *image;
    CGSize size = CGSizeMake(9, 80);
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor *borderColor = [UIColor hx_colorWithHexRGBAString:@"#e7e7e7"];
    
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
    
    CGContextMoveToPoint(context, size.width/2, 0);
    CGContextAddLineToPoint(context, size.width/2, size.height);
    CGContextDrawPath(context, kCGPathStroke);
    
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextAddArc(context, size.width/2, 40, 4.5, 0, 2*M_PI, YES);
    
    CGContextDrawPath(context, kCGPathFillStroke);
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    return image;
}

+ (UIImage *)imageWithStockPoolListRightBackground {
    UIImage *image;
    CGSize size = CGSizeMake(60, 100);
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor *borderColor = [UIColor hx_colorWithHexRGBAString:@"#e7e7e7"];
    CGFloat corner = 3.f;
    
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    
    CGContextMoveToPoint(context, 11, 0);
    CGContextAddArcToPoint(context, 8, 0, 8, 3, corner);
    
    CGContextAddLineToPoint(context, 8, 16);
    CGContextAddLineToPoint(context, 0, 24);
    CGContextAddLineToPoint(context, 8, 32);
    CGContextAddArcToPoint(context, 8, 100, 11, 100, corner);
    
    CGContextAddLineToPoint(context, 57, 100);
    CGContextAddArcToPoint(context, 60, 100, 60, 97, corner);
    
    CGContextAddLineToPoint(context, 60, 3);
    CGContextAddArcToPoint(context, 60, 0, 57, 0, corner);
    CGContextAddLineToPoint(context, 11, 0);
    CGContextClosePath(context);
    
    CGContextDrawPath(context, kCGPathFillStroke);
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    return image;
}
@end
