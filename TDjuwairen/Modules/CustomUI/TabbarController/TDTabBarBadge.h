//
//  TDTabBarBadge.h
//  TDjuwairen
//
//  Created by zdy on 2017/8/7.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDTabBarBadge : UIButton
/**
 *  TabBar item badge value
 */
@property (nonatomic, copy) NSString *badgeValue;

/**
 *  TabBar's item count
 */
@property (nonatomic, assign) NSInteger tabBarItemCount;

/**
 *  TabBar item's badge title font
 */
@property (nonatomic, strong) UIFont *badgeTitleFont;
@end
