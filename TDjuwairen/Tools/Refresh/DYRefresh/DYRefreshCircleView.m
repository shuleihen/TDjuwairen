//
//  DYRefreshCircleView.m
//  TDjuwairen
//
//  Created by zdy on 2017/8/8.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "DYRefreshCircleView.h"


@implementation DYRefreshCircleView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.progress = 0.0f;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setProgress:(CGFloat)progress {
    [super setProgress:progress];
    
    [self setNeedsDisplay];
}

- (void)reset {
    self.progress = 0.0f;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    UIColor *backgroundStrokeColor = [UIColor grayColor];
    UIColor *strokeColor = self.circleColor;
    CGFloat lineWidth = 2;
    CGPoint center = CGPointMake(rect.size.width/2, rect.size.height/2);
    CGFloat radius = 12.0f;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetShouldAntialias(context, true);
    
    // 先画一个背景圆
    CGContextSetStrokeColorWithColor(context, backgroundStrokeColor.CGColor);
    CGContextSetLineWidth(context, lineWidth);
    CGContextAddArc(context, center.x, center.y, radius, 0, M_PI*2, NO);
    CGContextStrokePath(context);
    
    // 绘制前景圆
    CGContextSetStrokeColorWithColor(context, strokeColor.CGColor);
    CGContextSetLineWidth(context, lineWidth);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    
    CGFloat endAngle = self.progress*M_PI*2 - M_PI_2;
    
    CGContextAddArc(context, center.x, center.y, radius, -M_PI_2, endAngle, NO);
    CGContextStrokePath(context);
}

- (void)startAnimation {
    
    self.progress = 0.0f;
    
    CGRect rect = self.bounds;
    CGPoint center = CGPointMake(rect.size.width/2, rect.size.height/2);
    CGFloat radius = 12.0f;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:-M_PI_2 endAngle:(-M_PI_2+M_PI_2*0.6) clockwise:YES];
    [path strokeWithBlendMode:kCGBlendModeNormal alpha:0.0f];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = self.bounds;
    layer.backgroundColor = [UIColor clearColor].CGColor;
    layer.fillColor = [UIColor whiteColor].CGColor;
    layer.strokeColor = self.circleColor.CGColor;
    layer.contentsScale = [UIScreen mainScreen].scale;
    layer.lineWidth = 2;
    layer.path = path.CGPath;
    
    CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimation.fromValue = @(-M_PI_2);
    rotateAnimation.toValue = @(M_PI*2-M_PI_2);
    rotateAnimation.duration = 0.55f;
    rotateAnimation.repeatCount = MAXFLOAT;
    
    [layer addAnimation:rotateAnimation forKey:@"cicleAnimation"];
    [self.layer addSublayer:layer];
}

- (void)stopAnimation {
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
}
@end
