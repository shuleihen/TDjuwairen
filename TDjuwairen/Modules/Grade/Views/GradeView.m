//
//  GradeView.m
//  TDjuwairen
//
//  Created by zdy on 2017/1/16.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "GradeView.h"

@implementation GradeNode

@end

@implementation GradeView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setGrades:(NSArray *)grades {
    _grades = grades;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGFloat h = CGRectGetHeight(rect);
    CGFloat radius = (h - 20*2)/2;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 画周边边线和连线
    CGPoint points[8];
    int i=0;
    for (GradeNode *node in self.nodes) {
        CGPoint point = [self pointWithRadian:node.radian withRadius:radius];
        points[i] = point;
        
        CGPoint titlePoint;
        titlePoint.x = point.x + node.offx;
        titlePoint.y = point.y + node.offy;
        
        [node.title drawAtPoint:titlePoint withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f],
                                                        NSForegroundColorAttributeName: [UIColor whiteColor]}];
        i++;
    }
    
    for (int j=0; j<4; j++) {
        CGPoint start = points[j];
        CGPoint end = points[j+4];
        CGContextMoveToPoint(context, start.x, start.y);
        CGContextAddLineToPoint(context, end.x, end.y);
    }
    
    CGContextAddLines(context, points, 8);
    CGContextClosePath(context);
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:1 alpha:0.5].CGColor);
    CGContextSetLineWidth(context, 1);
    
    CGContextStrokePath(context);
    
    // 绘制评级分数
    if ([self.grades count] >=8) {
        int z =0;
        CGPoint gPoints[8];
        for (NSString *value in self.grades) {
            CGFloat va = [value floatValue];
            CGFloat gradius = va *radius/100;
            
            GradeNode *node = self.nodes[z];
            CGPoint point = [self pointWithRadian:node.radian withRadius:gradius];
            gPoints[z] = point;
            z++;
        }
        CGContextAddLines(context, gPoints, 8);
        CGContextClosePath(context);
        CGContextSetFillColorWithColor(context, [UIColor colorWithWhite:1.0f alpha:0.5f].CGColor);
        CGContextDrawPath(context, kCGPathFill);
    }
}

- (CGPoint)pointWithRadian:(double)radian withRadius:(CGFloat)radius {
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGPoint point;
    point.x = sin(radian)*radius + center.x;
    point.y = center.y - cos(radian)*radius;
    return point;
}


- (NSArray *)nodes {
    if (!_nodes) {
        GradeNode *one = [[GradeNode alloc] init];
        one.title = @"德";
        one.radian = 0;
        one.offx = -6;
        one.offy = -20;
        
        GradeNode *two = [[GradeNode alloc] init];
        two.title = @"智";
        two.radian = M_PI_4;
        two.offx = 6;
        two.offy = -15;
        
        GradeNode *three = [[GradeNode alloc] init];
        three.title = @"财";
        three.radian = M_PI_2;
        three.offx = 5;
        three.offy = -6;
        
        GradeNode *four = [[GradeNode alloc] init];
        four.title = @"势";
        four.radian = M_PI*3/4;
        four.offx = 3;
        four.offy = 0;
        
        GradeNode *five = [[GradeNode alloc] init];
        five.title = @"创";
        five.radian = M_PI;
        five.offx = -6;
        five.offy = 5;
        
        GradeNode *six = [[GradeNode alloc] init];
        six.title = @"观";
        six.radian = -M_PI*3/4;
        six.offx = -20;
        six.offy = 0;
        
        GradeNode *seven = [[GradeNode alloc] init];
        seven.title = @"透";
        seven.radian = -M_PI_2;
        seven.offx = -20;
        seven.offy = -6;
        
        GradeNode *eight = [[GradeNode alloc] init];
        eight.title = @"行";
        eight.radian = -M_PI_4;
        eight.offx = -15;
        eight.offy = -15;
        
        _nodes = @[one,two,three,four,five,six,seven,eight];
    }
    return _nodes;
}
@end
