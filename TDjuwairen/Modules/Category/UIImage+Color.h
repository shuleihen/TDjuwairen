//
//  UIImage+Color.h
//  baiwandian
//
//  Created by zdy on 15/10/10.
//  Copyright © 2015年 xinyunlian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Color)
+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithSize:(CGSize)size withColor:(UIColor *)color;
+ (UIImage *)imageWithSize:(CGSize)size withColor:(UIColor *)color withCornerWidth:(CGFloat)cornerWidth;
+ (UIImage *)imageWithSize:(CGSize)size withColor:(UIColor *)color withBackgroundColor:(UIColor *)backgroudColor withCornerWidth:(CGFloat)cornerWidth;
@end
