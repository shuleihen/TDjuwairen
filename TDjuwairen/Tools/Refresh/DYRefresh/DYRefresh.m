//
//  DYRefresh.m
//  DYRefresh
//
//  Created by zdy on 2017/3/24.
//  Copyright © 2017年 lianlianpay. All rights reserved.
//

#import "DYRefresh.h"
#import "DYRefreshAliveView.h"
#import "DYRefreshCircleView.h"

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
    NSInteger _dataCount;
}

@property (nonatomic, strong) DYRefreshBaseView *contentView;
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
        
        self.status = kDYRefreshStatusNone;
        self.type = kDYRefreshTypeAlive;
        self.backgroundColor = [UIColor clearColor];
        self.circleColor = [UIColor blueColor];
        
        [_scrollView addSubview:self];
    }
    return self;
}

- (void)setType:(DYRefreshType)type {
    _type = type;
    
    if (self.contentView && self.contentView.superview) {
        [self.contentView removeFromSuperview];
    }
    
    switch (type) {
        case kDYRefreshTypeAlive:
            self.contentView = [[DYRefreshAliveView alloc] initWithFrame:self.bounds];
            break;
        case kDYRefreshTypeNormal:
            self.contentView = [[DYRefreshCircleView alloc] initWithFrame:self.bounds];
            break;
        default:
            break;
    }
    
    [self addSubview:self.contentView];
}

- (void)setCircleColor:(UIColor *)circleColor {
    _circleColor = circleColor;
    
    if (self.type == kDYRefreshTypeNormal) {
        DYRefreshCircleView *circleView = (DYRefreshCircleView *)self.contentView;
        circleView.circleColor = circleColor;
    }
}

- (void)setStatus:(DYRefreshStatus)status {
    _status = status;
    
    switch (status) {
        case kDYRefreshStatusNone:
        {
            UIEdgeInsets contentInset = _scrollView.contentInset;
            contentInset.top = 0;
            _scrollView.contentInset = contentInset;
            
            [self.contentView reset];
            break;
        }
        case kDYRefreshStatusPullDown:
            
            break;
        case kDYRefreshStatusLoading:
        {
            UIEdgeInsets contentInset = _scrollView.contentInset;
            contentInset.top = kDYRefreshHeaderViewHeight;
            _scrollView.contentInset = contentInset;
            
            [self.contentView startAnimation];
            
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
            
            [self.contentView stopAnimation];
            [self.contentView reset];
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
    [UIView animateWithDuration:0.36 animations:^{
        self.status = kDYRefreshStatusDone;
    }];
}

- (void)endRefreshWithDataCount:(NSInteger)dataCount {
    if (self.status == kDYRefreshStatusDone) {
        return;
    }
    
    if (dataCount == 0) {
        [self endRefresh];
    } else {
        self.contentView.result = [NSString stringWithFormat:@"更新了%ld条内容",(long)dataCount];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3 animations:^{
                self.status = kDYRefreshStatusDone;
            }];
        });
    }
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
            self.contentView.progress = progress;
            self.status = kDYRefreshStatusPullDown;
        } else if (offy >= kDYRefreshHeaderViewHeight) {
            self.contentView.progress = 1.0f;
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

