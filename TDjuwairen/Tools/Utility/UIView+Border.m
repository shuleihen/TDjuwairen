//
//  UIView+Border.m
//  TDjuwairen
//
//  Created by ZYP-MAC on 17/4/26.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "UIView+Border.h"
#import "HexColors.h"
@implementation UIView (Border)
// 加边框
- (void)addBorder:(CGFloat)borderWidth borderColor:(UIColor *)borderColor {
    self.layer.borderWidth = borderWidth;
    self.layer.borderColor = borderColor.CGColor;
}


// 加边框(rgb颜色)
- (void)addBorder:(CGFloat)borderWidth borderRGBColorString:(NSString *)colorStr {

    self.layer.borderWidth = borderWidth;
    self.layer.borderColor = [UIColor hx_colorWithHexRGBAString:colorStr].CGColor;
}

/// 设置边框颜色
- (void)configBorderColor:(UIColor *)borderColor {

    self.layer.borderColor = borderColor.CGColor;
}

/// 设置边框颜色(rgb颜色)
- (void)configBorderRGBColorString:(NSString *)colorStr {
    self.layer.borderColor = [UIColor hx_colorWithHexRGBAString:colorStr].CGColor;
    
}


- (void)cutCircular:(NSInteger)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}
@end
