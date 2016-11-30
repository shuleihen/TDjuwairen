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
- (id)initWithTitle:(NSString *)title image:(UIImage *)image highlightedImage:(UIImage *)highlightedImage;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) BOOL locked;
@property (nonatomic, copy) void (^clickBlock)(NSInteger index);

@end

@interface SurveyDetailSegmentView : UIView
@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) NSArray *segments;
@end
