//
//  UIViewController+NoData.m
//  TDjuwairen
//
//  Created by zdy on 2017/7/27.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "UIViewController+NoData.h"
#import "YXNoDataView.h"
#import <objc/runtime.h>

static char YXNoDataViewKey;

@implementation UIViewController (NoData)
- (YXNoDataView *)noDataView
{
    return objc_getAssociatedObject(self, &YXNoDataViewKey);
}

- (void)setNoDataView:(YXNoDataView *)noDataView
{
    objc_setAssociatedObject(self, &YXNoDataViewKey, noDataView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setupNoDataImage:(UIImage *)image message:(NSString *)message {
    self.noDataView = [[YXNoDataView alloc] initWithImage:image withMessage:message withOffy:64];
}

- (void)showNoDataView:(BOOL)isShow {
    if (isShow) {
        if (!self.noDataView.superview) {
            [self.view addSubview:self.noDataView];
        }
    } else {
        if (self.noDataView.superview) {
            [self.noDataView removeFromSuperview];
        }
    }
}
@end
