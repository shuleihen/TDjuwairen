//
//  TDTabBarItem.h
//  TDjuwairen
//
//  Created by zdy on 2017/8/7.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDTabBarItem : UIButton

/**
 *  TabBar item
 */
@property (nonatomic, strong) UITabBarItem *tabBarItem;

/**
 *  TabBar's item count
 */
@property (nonatomic, assign) NSInteger tabBarItemCount;

/**
 *  TabBar item title color
 */
@property (nonatomic, strong) UIColor *itemTitleColor;

/**
 *  TabBar selected item title color
 */
@property (nonatomic, strong) UIColor *selectedItemTitleColor;

/**
 *  TabBar item title font
 */
@property (nonatomic, strong) UIFont *itemTitleFont;

/**
 *  TabBar item's badge title font
 */
@property (nonatomic, strong) UIFont *badgeTitleFont;

/**
 *  TabBar item image ratio
 */
@property (nonatomic, assign) CGFloat itemImageRatio;

/**
 *  TabBar item init func
 */
- (instancetype)initWithItemImageRatio:(CGFloat)itemImageRatio;

@end
