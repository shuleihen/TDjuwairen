//
//  YXUnread.m
//  baiwandian
//
//  Created by zdy on 15/10/30.
//  Copyright © 2015年 xinyunlian. All rights reserved.
//

#import "YXUnread.h"

@implementation YXUnread

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.hidden = YES;
        self.clipsToBounds = NO;
        
        _titleColor = [UIColor whiteColor];
        _color = [UIColor redColor];
        _count = 0;
        
    }
    return self;
}

- (void)setCount:(NSInteger)count
{
    self.hidden = (count == 0);
    
    _count = count;
    
    // 是否要修改frame
    NSString *content = [NSString stringWithFormat:@"%ld",(long)_count];
    
    if (_count > 99) {
        // 4位数显示99+
        content = @"99+";
    }
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:10],
                                 NSBackgroundColorAttributeName:[UIColor clearColor],
                                 NSForegroundColorAttributeName:_titleColor};
    CGSize size = [content sizeWithAttributes:attributes];
    
//    CGRect titleRect = CGRectMake((rect.size.width-size.width)/2, (rect.size.height-size.height)/2-1, size.width, size.height);
    
    CGFloat imageH = MAX(MAX(size.height + 4, _backgroudImage.size.height),12);
    CGFloat imageW = MAX(MAX(size.width + 8, _backgroudImage.size.width),imageH);
    
//    CGRect imageRect = CGRectMake((rect.size.width-imageW)/2, (rect.size.height-imageH)/2, imageW, imageH);
    
    self.bounds = CGRectMake(0, 0, imageW, imageH);
    
    [self setNeedsDisplay];
}

- (void)setBackgroudImage:(UIImage *)backgroudImage
{
    _backgroudImage = backgroudImage;
    
    [self setNeedsDisplay];
}

- (void)setTitleColor:(UIColor *)titleColor
{
    _titleColor = titleColor;
    
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    if (0 == _count) {
        return;
    }
    
    NSString *content = [NSString stringWithFormat:@"%ld",(long)_count];
    
    if (_count > 99) {
        // 4位数显示99+
        content = @"99+";
    }
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:10],
                                 NSBackgroundColorAttributeName:[UIColor clearColor],
                                 NSForegroundColorAttributeName:_titleColor};
    CGSize size = [content sizeWithAttributes:attributes];
    
    CGRect titleRect = CGRectMake((rect.size.width-size.width)/2, (rect.size.height-size.height)/2-TDPixel, size.width, size.height);
    
    CGFloat imageH = MAX(MAX(size.height + 4, _backgroudImage.size.height),12);
    CGFloat imageW = MAX(MAX(size.width + 8, _backgroudImage.size.width),imageH);
    
    CGRect imageRect = CGRectMake((rect.size.width-imageW)/2, (rect.size.height-imageH)/2, imageW, imageH);
    
    if (_backgroudImage) {
        [_backgroudImage drawInRect:imageRect];
    }
    else {
        // 使用默认背景色
        CGPathRef path = [self drawBackgroundImagePathWithRect:imageRect];

        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, _color.CGColor);
        
        CGContextAddPath(context, path);

        CGContextDrawPath(context, kCGPathFill);
        
        CGPathRelease(path);
    }
    

    [content drawInRect:titleRect withAttributes:attributes];
}

- (CGPathRef)drawBackgroundImagePathWithRect:(CGRect)rect
{
    CGMutablePathRef path = CGPathCreateMutable();

    CGPathMoveToPoint(path, nil, rect.size.width-rect.size.height/2, 0);
    
    CGPathAddArc(path, nil, rect.size.width-rect.size.height/2, rect.size.height/2, rect.size.height/2, -M_PI/2, M_PI/2, NO);
    
    CGPathAddLineToPoint(path, nil, rect.size.height/2, rect.size.height);
    
    CGPathAddArc(path, nil, rect.size.height/2, rect.size.height/2, rect.size.height/2, M_PI/2, -M_PI/2, NO);
    
    return path;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.nextResponder touchesBegan:touches withEvent:event];
}
@end
