//
//  UILabel+TDLabel.h
//  TDjuwairen
//
//  Created by deng shu on 2017/8/12.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (TDLabel)

- (instancetype)initWithTitle:(NSString *)titleStr textColor:(UIColor *)textColor fontSize:(CGFloat)fontSize textAlignment:(NSTextAlignment)textAlignment;
- (instancetype)initWithTextColor:(UIColor *)textColor fontSize:(CGFloat)fontSize textLine:(CGFloat)textLine;

@end
