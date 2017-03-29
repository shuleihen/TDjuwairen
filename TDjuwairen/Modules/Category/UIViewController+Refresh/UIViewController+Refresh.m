//
//  UIViewController+Refresh.m
//  TDjuwairen
//
//  Created by zdy on 2017/3/29.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "UIViewController+Refresh.h"
#import "DYRefresh.h"
#import <objc/runtime.h>

static char *headerRefreshKey;

@implementation UIViewController (Refresh)
- (DYRefresh *)headerRefresh
{
    return objc_getAssociatedObject(self, &headerRefreshKey);
}

- (void)setHeaderRefresh:(DYRefresh *)headerRefresh
{
    objc_setAssociatedObject(self, &headerRefreshKey, headerRefresh, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)addHeaderRefreshWithScroll:(UIScrollView *)scrollView action:(SEL)action {
    self.headerRefresh = [[DYRefresh alloc] initWithScrollView:scrollView];
    self.headerRefresh.circleColor = TDThemeColor;
    [self.headerRefresh addTarget:self action:action];
}

- (void)endHeaderRefresh {
    [self.headerRefresh endRefresh];
}
@end
