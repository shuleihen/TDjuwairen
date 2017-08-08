//
//  TDTabBar.h
//  TDjuwairen
//
//  Created by zdy on 2017/8/7.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TDTabBar, TDTabBarItem;

@protocol TDTabBarDelegate <NSObject>

@optional

/**
 TabBar's item be selected handler
 */
- (void)tabBar:(TDTabBar *)tabBarView didSelectedItemFrom:(NSInteger)from to:(NSInteger)to;

- (BOOL)tabBar:(TDTabBar *)tabBarView shouldSelectItemIndex:(NSInteger)index;

- (void)tabBar:(TDTabBar *)tabBarView didSelectedCenter:(id)sender;
@end

@interface TDTabBar : UIView

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
 *  TabBar's item count
 */
@property (nonatomic, assign) NSInteger tabBarItemCount;

/**
 *  TabBar's selected item
 */
@property (nonatomic, strong) TDTabBarItem *selectedItem;


@property (nonatomic, strong) UIButton *centerItem;

/**
 *  TabBar items array
 */
@property (nonatomic, strong) NSMutableArray *tabBarItems;

/**
 *  TabBar delegate
 */
@property (nonatomic, weak) id<TDTabBarDelegate> delegate;

/**
 *  Add tabBar item
 */
- (void)addTabBarItem:(UITabBarItem *)item;
@end
