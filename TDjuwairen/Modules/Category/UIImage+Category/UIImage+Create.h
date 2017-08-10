//
//  UIImage+Create.h
//  TDjuwairen
//
//  Created by zdy on 2016/12/29.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface UIImage (Create)
+ (UIImage *)imageWithSize:(CGSize)size backgroudColor:(UIColor *)bgColor borderColor:(UIColor *)borderColor cornerRadius:(CGFloat)radius;
+ (UIImage *)imageWithSize:(CGSize)size backgroudColor:(UIColor *)bgColor borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)radius;
@end
