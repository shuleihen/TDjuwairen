//
//  YXTextFieldPanel.m
//  yixin_iphone
//
//  Created by zdy on 14-3-7.
//  Copyright (c) 2014年 Netease. All rights reserved.
//

#import "YXTextFieldPanel.h"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:1.0]

#define YXPixel             (1.0/[[UIScreen mainScreen] scale])
#define YXPixel_Offset      ((1 / [UIScreen mainScreen].scale) / 2)
#define YXSplitLineColor    UIColorFromRGB(0xdddddd)

@interface YXTextFieldPanel ()
@property (nonatomic, strong) UIImageView *backgroundView;
@end

@implementation YXTextFieldPanel
@synthesize textFieldCount = _textFieldCount;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        if (self.leftEdge == nil) {
            self.leftEdge = @(0.0f);
        }
    }
    return self;
}

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor whiteColor];
    if (self.leftEdge == nil) {
        self.leftEdge = @(0.0f);
    }
}

- (void)drawRect:(CGRect)rect
{
    NSInteger separatorCount = [self.textFieldCount integerValue];
    CGFloat left = [self.leftEdge floatValue];
    CGRect frame = self.bounds;
    
    CGContextRef contentRef = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(contentRef, YXPixel);
    
    // 画上下边界
    CGContextSetStrokeColorWithColor(contentRef, YXSplitLineColor.CGColor);
    CGContextMoveToPoint(contentRef, 0, YXPixel_Offset);
    CGContextAddLineToPoint(contentRef, CGRectGetWidth(frame), YXPixel_Offset);
    
    CGContextMoveToPoint(contentRef, 0, CGRectGetHeight(frame) -YXPixel);
    CGContextAddLineToPoint(contentRef, CGRectGetWidth(frame), CGRectGetHeight(frame) -YXPixel);
    CGContextStrokePath(contentRef);
    
    if (separatorCount > 0) {
        
        CGFloat itemHeight = frame.size.height/separatorCount;
        
        CGContextSetStrokeColorWithColor(contentRef, YXSplitLineColor.CGColor);
        
        for (int i = 1; i< separatorCount; i++) {
            CGContextMoveToPoint(contentRef, left, i*itemHeight -YXPixel);
            CGContextAddLineToPoint(contentRef, CGRectGetWidth(frame), i*itemHeight -YXPixel);
        }
        CGContextStrokePath(contentRef);
    }
}

- (void)setTextFieldCount:(NSNumber *)textFieldCount
{
    if (_textFieldCount != textFieldCount) {
        _textFieldCount = textFieldCount;
        
        [self setNeedsDisplay];
    }
}

- (void)setLeftEdge:(NSNumber *)leftEdge
{
    if (_leftEdge != leftEdge) {
        _leftEdge = leftEdge;
        
        [self setNeedsDisplay];
    }
}
@end
