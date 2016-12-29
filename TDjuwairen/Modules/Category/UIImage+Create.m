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
    UIImage *image;
    
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
    CGContextSetFillColorWithColor(context, bgColor.CGColor);
    
    CGContextMoveToPoint(context, size.width, size.height-radius);  // 开始坐标右边开始
    CGContextAddArcToPoint(context, size.width, size.height, size.width-radius, size.height, radius);  // 右下角角度
    CGContextAddArcToPoint(context, 0, size.height, 0, size.height-radius, radius); // 左下角角度
    CGContextAddArcToPoint(context, 0, 0, size.width-radius, 0, radius); // 左上角
    CGContextAddArcToPoint(context, size.width, 0, size.width, size.height-radius, radius); // 右上角
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke); 
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    return image;
}
@end
