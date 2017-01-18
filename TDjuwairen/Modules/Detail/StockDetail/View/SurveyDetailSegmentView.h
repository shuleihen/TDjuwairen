//
//  SurveyDetailSegmentView.h
//  TDjuwairen
//
//  Created by zdy on 2016/11/29.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SurveyDetailSegmentView;
@protocol SurveyDetailSegmentDelegate <NSObject>

- (void)didSelectedSegment:(SurveyDetailSegmentView *)segmentView withIndex:(NSInteger)index;
@end

@interface SurveyDetailSegmentItem : UIView
- (id)initWithTitle:(NSString *)title image:(UIImage *)image selectedBackgroundColor:(UIColor *)selectedBackgroundColor;

@property (nonatomic, strong) UIColor *selectedBackgroundColor;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) BOOL locked;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, copy) void (^clickBlock)(NSInteger index);

@end

@interface SurveyDetailSegmentView : UIView
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) NSArray *segments;
@property (nonatomic, assign) BOOL isLock;

- (void)setLocked:(BOOL)locked withIndex:(NSInteger)index;

- (void)changedSelectedIndex:(NSInteger)selectedIndex executeDelegate:(BOOL)execute;
@end

