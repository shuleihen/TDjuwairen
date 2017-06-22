//
//  DYRefresh.m
//  DYRefresh
//
//  Created by zdy on 2017/3/24.
//  Copyright © 2017年 lianlianpay. All rights reserved.
//

#import "DYRefresh.h"

#define kDYRefreshHeaderViewHeight 70
#define kDYRefreshCircleHeight  26
#define kDYStockLineWidth   2

NSString *const DYRefreshKeyPathContentOffset = @"contentOffset";
NSString *const DYRefreshKeyPathContentInset = @"contentInset";
NSString *const DYRefreshKeyPathContentSize = @"contentSize";
NSString *const DYRefreshKeyPathPanState = @"state";

@interface DYRefresh ()<UIGestureRecognizerDelegate>
{
    id _target;
    SEL _action;
    UIScrollView *_scrollView;
}
@property (nonatomic, strong) DYRefreshCircleView *circleView;
@end

@implementation DYRefresh

- (void)dealloc
{
    [_scrollView removeObserver:self forKeyPath:DYRefreshKeyPathContentSize];
    [_scrollView.panGestureRecognizer removeObserver:self forKeyPath:DYRefreshKeyPathPanState];
}

- (id)initWithScrollView:(UIScrollView *)scrollView {
    CGRect rect = CGRectMake(0, -kDYRefreshHeaderViewHeight, kScreenWidth, kDYRefreshHeaderViewHeight);
    
    if (self = [super initWithFrame:rect]) {

        // 添加tableview 的contentOffset 监听
        [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        _scrollView = scrollView;
        
        
        // 添加tableview 的pan 手势状态监听
        [_scrollView.panGestureRecognizer addObserver:self forKeyPath:DYRefreshKeyPathPanState options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        
        // 添加circle
        _circleView = [[DYRefreshCircleView alloc] initWithFrame:CGRectMake(0, 0, kDYRefreshCircleHeight, kDYRefreshCircleHeight)];
        _circleView.center = CGPointMake(rect.size.width/2, rect.size.height/2);
        [self addSubview:_circleView];
        
        self.status = kDYRefreshStatusNone;
        self.backgroundColor = [UIColor clearColor];
        self.circleColor = [UIColor blueColor];
        
        [_scrollView addSubview:self];
    }
    return self;
}

- (void)setCircleColor:(UIColor *)circleColor {
    _circleColor = circleColor;
    
    self.circleView.circleColor = circleColor;
}

- (void)setStatus:(DYRefreshStatus)status {
    _status = status;
    
    switch (status) {
        case kDYRefreshStatusNone:
        {
            UIEdgeInsets contentInset = _scrollView.contentInset;
            contentInset.top = 0;
            _scrollView.contentInset = contentInset;
            
            [self.circleView removeCircleAnimation];
            break;
        }
        case kDYRefreshStatusPullDown:
            
            break;
        case kDYRefreshStatusLoading:
        {
            UIEdgeInsets contentInset = _scrollView.contentInset;
            contentInset.top = kDYRefreshHeaderViewHeight;
            _scrollView.contentInset = contentInset;
            
            [self.circleView addCircleAnimation];
            
            if (_target && _action) {
                
                [_target performSelector:_action];
            }
        }
            
            break;
        case kDYRefreshStatusDone:
        {
            UIEdgeInsets contentInset = _scrollView.contentInset;
            contentInset.top = 0;
            _scrollView.contentInset = contentInset;
            
            [self.circleView removeCircleAnimation];
            break;
        }
        default:
            break;
    }
}

- (void)addTarget:(id)target action:(SEL)action {
    _target = target;
    _action = action;
}

- (void)endRefresh {
    self.status = kDYRefreshStatusNone;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGPoint point = [[change objectForKey:NSKeyValueChangeNewKey] CGPointValue];
        if (point.y>0) {
            return;
        }
        
        CGFloat circleOffx = (kDYRefreshHeaderViewHeight - kDYRefreshCircleHeight)/2;
        CGFloat offy = fabs(point.y);
        
        if ((offy > (kDYRefreshHeaderViewHeight - circleOffx)) &&
            (offy < kDYRefreshHeaderViewHeight)) {
            CGFloat progress = 1-(kDYRefreshHeaderViewHeight - offy)/circleOffx;
            self.circleView.progress = progress;
            self.status = kDYRefreshStatusPullDown;
        } else if (offy >= kDYRefreshHeaderViewHeight) {
            self.circleView.progress = 1.0f;
            self.status = kDYRefreshStatusTrigger;
        }
        
    } else if ([keyPath isEqualToString:DYRefreshKeyPathPanState]) {
        UIGestureRecognizerState status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        if (status == UIGestureRecognizerStateEnded) {
            if (self.status == kDYRefreshStatusTrigger) {
                self.status = kDYRefreshStatusLoading;
            }
        } else {
            
        }
    }
}
@end


#pragma mark -

@implementation DYRefreshCircleView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.progress = 0.0f;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setProgress:(CGFloat)progress {
    
    if (progress > 1.0f) {
        progress = 1.0f;
    } else if (progress < 0.0) {
        progress = 0.0f;
    }
    
    _progress = progress;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    // Drawing code

    UIColor *backgroundStrokeColor = [UIColor grayColor];
    UIColor *strokeColor = self.circleColor;
    CGFloat lineWidth = kDYStockLineWidth;
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

- (void)addCircleAnimation {
    
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
    layer.lineWidth = kDYStockLineWidth;
    layer.path = path.CGPath;
    
    CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimation.fromValue = @(-M_PI_2);
    rotateAnimation.toValue = @(M_PI*2-M_PI_2);
    rotateAnimation.duration = 0.55f;
    rotateAnimation.repeatCount = MAXFLOAT;
    
    [layer addAnimation:rotateAnimation forKey:@"cicleAnimation"];
    [self.layer addSublayer:layer];
}

- (void)removeCircleAnimation {
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
}
@end
