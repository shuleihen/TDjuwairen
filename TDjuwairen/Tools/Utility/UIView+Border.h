//
//  UIView+Border.h
//  TDjuwairen
//
//  Created by ZYP-MAC on 17/4/26.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Border)
// 加边框
- (void)addBorder:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;
// 加边框(rgb颜色)
- (void)addBorder:(CGFloat)borderWidth borderRGBColorString:(NSString *)colorStr;

/// 设置边框颜色
- (void)configBorderColor:(UIColor *)borderColor;

/// 设置边框颜色(rgb颜色)
- (void)configBorderRGBColorString:(NSString *)colorStr;

/// 切圆角
- (void)cutCircular:(NSInteger)cornerRadius;

/// 切角，加边框
- (void)cutCircularRadius:(NSInteger)cornerRadius addBorder:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;
/// 切角，加边框(rgb颜色)
- (void)cutCircularRadius:(NSInteger)cornerRadius addBorder:(CGFloat)borderWidth borderRGBColorString:(NSString *)colorStr;
@end
