//
//  UIViewController+Loading.m
//  TDjuwairen
//
//  Created by zdy on 2017/3/29.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "UIViewController+Loading.h"
#import "ZFCWaveActivityIndicatorView.h"
#import <objc/runtime.h>

static char waveActivityIndicatorKey;

@implementation UIViewController (Loading)
- (ZFCWaveActivityIndicatorView *)waveActivityIndicator
{
    return objc_getAssociatedObject(self, &waveActivityIndicatorKey);
}

- (void)setWaveActivityIndicator:(ZFCWaveActivityIndicatorView *)waveActivityIndicator
{
    objc_setAssociatedObject(self, &waveActivityIndicatorKey, waveActivityIndicator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showLoadingAnimationInCenter:(CGPoint)center {
    self.waveActivityIndicator = [[ZFCWaveActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    self.waveActivityIndicator.center = center;
    [self.view addSubview:self.waveActivityIndicator];
    
    [self.waveActivityIndicator startAnimating];
}

- (void)removeLoadingAnimation {
    [self.waveActivityIndicator stopAnimating];
    
    if (self.waveActivityIndicator.superview) {
        [self.waveActivityIndicator removeFromSuperview];
    }
}
@end
