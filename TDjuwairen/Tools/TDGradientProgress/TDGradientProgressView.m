//
//  TDGradientProgressView.m
//  TDjuwairen
//
//  Created by zdy on 2017/8/10.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "TDGradientProgressView.h"

@implementation TDGradientProgressView

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    CAShapeLayer *back = [CAShapeLayer layer];
    back.frame = rect;
    back.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#F0EFF2"].CGColor;
    back.cornerRadius = CGRectGetHeight(rect)/2;
    [self.layer addSublayer:back];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.cornerRadius = CGRectGetHeight(rect)/2;
    gradientLayer.colors = @[(__bridge id)[UIColor hx_colorWithHexRGBAString:@"#25B8F3"].CGColor,(__bridge id)[UIColor hx_colorWithHexRGBAString:@"#3B90F7"].CGColor];
    gradientLayer.startPoint = CGPointMake(1, 0);
    gradientLayer.endPoint = CGPointMake(0, 0);
    gradientLayer.frame = CGRectMake(0, 0, self.progress*rect.size.width, rect.size.height);
    [self.layer addSublayer:gradientLayer];
}
@end
