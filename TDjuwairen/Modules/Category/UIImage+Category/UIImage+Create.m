//
//  UIImage+Create.m
//  TDjuwairen
//
//  Created by zdy on 2016/12/29.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "UIImage+Create.h"

@implementation UIImage (Create)
+ (UIImage *)imageWithSize:(CGSize)size backgroudColor:(UIColor *)bgColor borderColor:(UIColor *)borderColor cornerRadius:(CGFloat)radius {
    
    return [UIImage imageWithSize:size backgroudColor:bgColor borderColor:borderColor borderWidth:TDPixel cornerRadius:radius];
}

+ (UIImage *)imageWithSize:(CGSize)size backgroudColor:(UIColor *)bgColor borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)radius {

    UIImage *image;
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, borderWidth);
    CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
    CGContextSetFillColorWithColor(context, bgColor.CGColor);
    
    CGContextMoveToPoint(context, size.width-borderWidth/2, size.height-radius-borderWidth/2);  // 开始坐标右边开始
    CGContextAddArcToPoint(context, size.width-borderWidth/2, size.height-borderWidth/2, size.width-radius-borderWidth/2, size.height-borderWidth/2, radius);  // 右下角角度
    CGContextAddArcToPoint(context, 0+borderWidth/2, size.height-borderWidth/2, 0+borderWidth/2, size.height-radius+borderWidth/2, radius); // 左下角角度
    CGContextAddArcToPoint(context, 0+borderWidth/2, 0+borderWidth/2, size.width-radius+borderWidth/2, 0+borderWidth/2, radius); // 左上角
    CGContextAddArcToPoint(context, size.width-borderWidth/2, 0+borderWidth/2, size.width-borderWidth/2, size.height-radius+borderWidth/2, radius); // 右上角
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    return image;
}
@end
