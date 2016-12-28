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


@implementation StockWheelView
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.type = kStockSZ;
}

- (void)setIndex:(CGFloat)index {
    _index = index;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    // 轮盘中心点
    CGPoint wheelCenter = CGPointMake(CGRectGetWidth(self.bounds)/2, 80);
    // 圆盘半径
    CGFloat radius = 75.5f;
    
    
    UIImage *image = [UIImage imageNamed:@"icon_turntable"];
    [image drawAtPoint:CGPointMake((rect.size.width-image.size.width)/2, 0)];
    
    
    // 1、上证猜中10倍奖励，差值在±0.5之内奖励5倍，±2.5之内2倍奖励，+-5（不输不赢），大于±5（输，筹码不归还）
    // 2、创业板猜中10倍，差值为0.3，1.5，3.5
    for (WheelScale *scale in [self scalesWithType:kStockSZ]) {
        double radin = [self radinFromDu:scale.du];
        CGPoint point = [self pointWithRadin:radin withRadius:radius withWheelCenter:wheelCenter];
        point.x += scale.offx;
        point.y += scale.offy;
        
        NSString *indexString = [NSString stringWithFormat:@"%.02f",self.index+scale.scale];
        [indexString drawAtPoint:point withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:9.0f],
                                                        NSForegroundColorAttributeName: [UIColor hx_colorWithHexRGBAString:@"cccccc"]}];
    }
}



// r 为弧度单位
- (CGPoint)pointWithRadin:(double)radian withRadius:(CGFloat)radius withWheelCenter:(CGPoint)wheelCenter{
    CGPoint point;
    point.x = sin(radian)*radius + wheelCenter.x;
    point.y = radius - cos(radian)*radius;
    return point;
}

- (double)radinFromDu:(CGFloat)du {
    return M_PI*(du/180);
}

- (NSArray *)scalesWithType:(StockType)type{
    WheelScale *one = [[WheelScale alloc] init];
    one.du = 40;
    one.offx = 2;
    one.offy = -4;
    switch (type) {
        case kStockSZ:
            one.scale = +0.5;
            break;
        case kStockCY:
            one.scale = +0.3;
            break;
        default:
            break;
    }
    
    WheelScale *two = [[WheelScale alloc] init];
    two.du = 80;
    two.offx = 1;
    two.offy = 0;
    switch (type) {
        case kStockSZ:
            two.scale = +2.5;
            break;
        case kStockCY:
            two.scale = +1.5;
            break;
        default:
            break;
    }
    
    WheelScale *third = [[WheelScale alloc] init];
    third.du = 120;
    third.offx = 0;
    third.offy = 0;
    switch (type) {
        case kStockSZ:
            third.scale = +5;
            break;
        case kStockCY:
            third.scale = +3.5;
            break;
        default:
            break;
    }
    
    WheelScale *four = [[WheelScale alloc] init];
    four.du = -40;
    four.offx = -40;
    four.offy = -4;
    switch (type) {
        case kStockSZ:
            four.scale = -0.5;
            break;
        case kStockCY:
            four.scale = -0.3;
            break;
        default:
            break;
    }
    
    WheelScale *five = [[WheelScale alloc] init];
    five.du = -80;
    five.offx = -40;
    five.offy = 0;
    switch (type) {
        case kStockSZ:
            five.scale = -2.5;
            break;
        case kStockCY:
            five.scale = -1.5;
            break;
        default:
            break;
    }
    
    WheelScale *six = [[WheelScale alloc] init];
    six.du = -120;
    six.offx = -40;
    six.offy = 0;
    switch (type) {
        case kStockSZ:
            six.scale = -5;
            break;
        case kStockCY:
            six.scale = -3.5;
            break;
        default:
            break;
    }
    
    return @[one,two,third,four,five,six];
}

@end
