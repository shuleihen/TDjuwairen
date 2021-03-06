//
//  UIViewController+Refresh.h
//  TDjuwairen
//
//  Created by zdy on 2017/3/29.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYRefresh.h"

@interface UIViewController (Refresh)
- (void)addHeaderRefreshWithScroll:(UIScrollView *)scrollView action:(SEL)action;
- (void)beginRefresh;
- (void)endHeaderRefresh;
- (void)endHeaderRefreshWithDataCount:(NSInteger)count;
@end
