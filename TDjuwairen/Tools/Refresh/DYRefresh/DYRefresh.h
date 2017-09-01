//
//  DYRefresh.h
//  DYRefresh
//
//  Created by zdy on 2017/3/24.
//  Copyright © 2017年 lianlianpay. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    kDYRefreshStatusNone    =0, // 初始状态
    kDYRefreshStatusPullDown=1, // 下拉过程中
    kDYRefreshStatusTrigger =2, // 下拉达到触发条件
    kDYRefreshStatusLoading =3, // 加载中
    kDYRefreshStatusDone    =4, // 完成
} DYRefreshStatus;

typedef enum : NSUInteger {
    kDYRefreshTypeNormal    =1,
    kDYRefreshTypeAlive     =2,
} DYRefreshType;

@interface DYRefresh : UIView
@property (nonatomic, strong) UIColor *circleColor;
@property (nonatomic, assign) DYRefreshStatus status;
@property (nonatomic, assign) DYRefreshType type;

- (id)initWithScrollView:(UIScrollView *)scrollView;
- (void)addTarget:(id)target action:(SEL)action;
- (void)beginRefresh;
- (void)endRefresh;
- (void)endRefreshWithDataCount:(NSInteger)dataCount;
@end


