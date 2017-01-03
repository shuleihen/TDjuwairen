//
//  StockWheelView.m
//  TDjuwairen
//
//  Created by zdy on 2016/12/26.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "StockWheelView.h"
#import "HexColors.h"

@implementation WheelScale

@end

@interface StockWheelView ()
{
    CGFloat wheelRadius;
    CGPoint wheelCenter;
}
@end

@implementation StockWheelView
- (void)awakeFromNib {
    [super awakeFromNib];
    
    if ([UIScreen mainScreen].bounds.size.width <= 320) {
        // iPhone 5 以下此次
        wheelRadius = 60.0f;
        wheelCenter = CGPointMake(100, 80);
    } else {
        wheelRadius = 75.5;
        wheelCenter = CGPointMake(125, 80);
    }
    
//    wheelCenter = CGPointMake(CGRectGetWidth(self.bounds)/2, 80);
    
    self.type = kStockSZ;
}

- (void)setIndex:(CGFloat)index {
    _index = index;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {

    /*  绘制轮盘刻度
        1、上证猜中10倍奖励，差值在±0.5之内奖励5倍，±2.5之内2倍奖励，+-5（不输不赢），大于±5（输，筹码不归还）
        2、创业板猜中10倍，差值为0.3，1.5，3.5
     */
    for (WheelScale *scale in [self scalesWithType:self.type]) {

        double radin = [self radinFromDu:scale.du];
        CGPoint point = [self pointWithRadin:radin withRadius:wheelRadius];
        point.x += scale.offx;
        point.y += scale.offy;
        
        NSString *indexString = [NSString stringWithFormat:@"%.02f",self.index+scale.scale];
        [indexString drawAtPoint:point withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:9.0f],
                                                        NSForegroundColorAttributeName: [UIColor hx_colorWithHexRGBAString:@"cccccc"]}];
    }
    
    // 绘制下注
    for (NSString *pri in self.buyIndexs) {

        double radin = [self radinWithPri:[pri floatValue]];
        CGPoint point = [self pointWithPri:[pri floatValue]];
        UIImage *key = [UIImage imageNamed:@"icon_key_small.png"];
        CGRect rect = CGRectMake(point.x - key.size.width/2, point.y-key.size.height/2, key.size.width, key.size.height);

        [key drawInRect:rect];
        
//        CAShapeLayer *layer = [CAShapeLayer layer];
//        layer.frame = rect;
//        
//        layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"icon_key_ver.png"].CGImage);
//        layer.transform = CATransform3DMakeRotation(radin, 1, 0, 0);
//        [self.layer addSublayer:layer];
    }
}

- (double)radinWithPri:(CGFloat)pri {
    CGFloat off = pri - self.index;
    
    BOOL isLose = YES;
    CGFloat du = 0.0;
    
    for (WheelScale *scale in [self scalesWithType:kStockSZ]) {
        
        if (off > scale.start && off <= scale.end) {
            CGFloat offdu = (scale.du>0)?-20:20;
            du = scale.du + offdu;
            
            isLose = NO;
            break;
        }
    }
    
    if (isLose) {
        // lost 区
        du = 180.0f;
    }
    
    double radin = [self radinFromDu:du];
    return radin;
}

- (CGPoint)pointWithPri:(CGFloat)pri {
    float off = pri - self.index;
    
    BOOL isLose = YES;
    CGFloat du = 0.0;
    
    for (WheelScale *scale in [self scalesWithType:kStockSZ]) {
        if (off > 0.00099) {
            // 正区间，左开右闭
            if (off > scale.start && off <= scale.end) {
                CGFloat offdu = (scale.du>0)?-20:20;
                du = scale.du + offdu;
                
                isLose = NO;
                break;
            }
        } else if (off < -0.00099) {
            // 负区间，左闭右开
            if (off >= scale.start && off < scale.end) {
                CGFloat offdu = (scale.du>0)?-20:20;
                du = scale.du + offdu;
                
                isLose = NO;
                break;
            }
        } else {
            // 猜中
            du = 0;
            isLose = NO;
            break;
        }
        
        
    }
    
    if (isLose) {
        // lost 区
        du = 180.0f;
    }
    
    double radin = [self radinFromDu:du];
    CGPoint point = [self pointWithRadin:radin withRadius:wheelRadius/2];
    return point;
}

// r 为弧度单位
- (CGPoint)pointWithRadin:(double)radian withRadius:(CGFloat)radius {
    CGPoint point;
    point.x = sin(radian)*radius + wheelCenter.x;
    point.y = wheelCenter.y - cos(radian)*radius;
    return point;
}

- (double)radinFromDu:(CGFloat)du {
    return M_PI*(du/180);
}

- (NSArray *)scalesWithType:(StockType)type{
    WheelScale *six = [[WheelScale alloc] init];
    six.du = -120;
    six.offx = -40;
    six.offy = -2;
    switch (type) {
        case kStockSZ:
            six.scale = -5;
            six.start = -5;
            six.end = -2.5;
            break;
        case kStockCY:
            six.scale = -3.5;
            six.start = -3.5;
            six.end = -1.5;
            break;
        default:
            break;
    }
    
    WheelScale *five = [[WheelScale alloc] init];
    five.du = -80;
    five.offx = -38;
    five.offy = -4;
    switch (type) {
        case kStockSZ:
            five.scale = -2.5;
            five.start = -2.5;
            five.end = -0.5;
            break;
        case kStockCY:
            five.scale = -1.5;
            five.start = -1.5;
            five.end = -0.3;
            break;
        default:
            break;
    }
    
    WheelScale *four = [[WheelScale alloc] init];
    four.du = -40;
    four.offx = -40;
    four.offy = -8;
    switch (type) {
        case kStockSZ:
            four.scale = -0.5;
            four.start = -0.5;
            four.end = 0;
            break;
        case kStockCY:
            four.scale = -0.3;
            four.start = -0.3;
            four.end = 0;
            break;
        default:
            break;
    }
    
    WheelScale *one = [[WheelScale alloc] init];
    one.du = 40;
    one.offx = 2;
    one.offy = -8;
    switch (type) {
        case kStockSZ:
            one.scale = 0.5;
            one.start = 0;
            one.end = 0.5;
            break;
        case kStockCY:
            one.scale = 0.3;
            one.start = 0;
            one.end = 0.3;
            break;
        default:
            break;
    }
    
    WheelScale *two = [[WheelScale alloc] init];
    two.du = 80;
    two.offx = 1;
    two.offy = -4;
    switch (type) {
        case kStockSZ:
            two.scale = +2.5;
            two.start = 0.5;
            two.end = 2.5;
            break;
        case kStockCY:
            two.scale = 1.5;
            two.start = 0.3;
            two.end = 1.5;
            break;
        default:
            break;
    }
    
    WheelScale *third = [[WheelScale alloc] init];
    third.du = 120;
    third.offx = 0;
    third.offy = -2;
    switch (type) {
        case kStockSZ:
            third.scale = 5;
            third.start = 2.5;
            third.end = 5;
            break;
        case kStockCY:
            third.scale = 3.5;
            third.start = 1.5;
            third.end = 3.5;
            break;
        default:
            break;
    }
    
    return @[six,five,four,one,two,third];
}

@end
