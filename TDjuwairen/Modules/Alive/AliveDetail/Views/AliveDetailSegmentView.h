//
//  AliveDetailSegmentControl.h
//  TDjuwairen
//
//  Created by zdy on 2017/6/13.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AliveDetailSegmentViewDelegate <NSObject>
- (void)didSelectedWithIndex:(NSInteger)selectedIndex;

@end

@interface AliveDetailSegmentView : UIView
@property (nonatomic, strong) UIView *arrow;
@property (nonatomic, weak) id<AliveDetailSegmentViewDelegate> delegate;
@end
