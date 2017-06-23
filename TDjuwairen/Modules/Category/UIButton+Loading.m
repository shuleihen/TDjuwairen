//
//  UIButton+Loading.m
//  TDjuwairen
//
//  Created by zdy on 2017/6/23.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "UIButton+Loading.h"

@implementation UIButton (Loading)
- (void)showLoading {
    self.titleLabel.hidden = YES;
    self.imageView.hidden = YES;
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    [indicator startAnimating];
    [self addSubview:indicator];
}

- (void)hiddenLoading {
    for (UIView *v in self.subviews) {
        if ([v isKindOfClass:[UIActivityIndicatorView class]]) {
            [v removeFromSuperview];
        }
    }
    
    self.titleLabel.hidden = NO;
    self.imageView.hidden = NO;
}
@end
