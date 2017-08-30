//
//  TDSegmentControl.h
//  TDjuwairen
//
//  Created by zdy on 2017/8/9.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDSegmentedControl : UIControl
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) NSDictionary *attributes;
@property (nonatomic, strong) NSDictionary *selectedAttributes;

- (id)initWithFrame:(CGRect)frame witItems:(NSArray *)items;
- (void)setupUnread:(BOOL)unread withIndex:(NSInteger)index;
- (void)setupSlideWithIndex:(NSInteger)index animation:(BOOL)animation;
@end
