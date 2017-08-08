//
//  TDTabBar.m
//  TDjuwairen
//
//  Created by zdy on 2017/8/7.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "TDTabBar.h"
#import "TDTabBarItem.h"
#import "TDTabBarBadge.h"

@implementation TDTabBar

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.centerItem = [[UIButton alloc] init];
        [self.centerItem setImage:[UIImage imageNamed:@"tab_release.png"] forState:UIControlStateNormal];
        [self.centerItem addTarget:self action:@selector(centerBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.centerItem];
    }
    return self;
}

- (NSMutableArray *)tabBarItems {
    
    if (_tabBarItems == nil) {
        
        _tabBarItems = [[NSMutableArray alloc] init];
    }
    return _tabBarItems;
}

- (void)addTabBarItem:(UITabBarItem *)item {
    
    TDTabBarItem *tabBarItem = [[TDTabBarItem alloc] initWithItemImageRatio:self.itemImageRatio];
    
    tabBarItem.badgeTitleFont         = self.badgeTitleFont;
    tabBarItem.itemTitleFont          = self.itemTitleFont;
    tabBarItem.itemTitleColor         = self.itemTitleColor;
    tabBarItem.selectedItemTitleColor = self.selectedItemTitleColor;
    
    tabBarItem.tabBarItemCount = self.tabBarItemCount;
    
    tabBarItem.tabBarItem = item;
    
    [tabBarItem addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
    
    [self addSubview:tabBarItem];
    
    [self.tabBarItems addObject:tabBarItem];
    
    if (self.tabBarItems.count == 1) {
        
        [self buttonClick:tabBarItem];
    }
}

- (void)buttonClick:(TDTabBarItem *)tabBarItem {
    
    if ([self.delegate respondsToSelector:@selector(tabBar:shouldSelectItemIndex:)]) {
        
        if (![self.delegate tabBar:self shouldSelectItemIndex:tabBarItem.tag]) {
            return;
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectedItemFrom:to:)]) {
        
        [self.delegate tabBar:self didSelectedItemFrom:self.selectedItem.tabBarItem.tag to:tabBarItem.tag];
    }
    
    self.selectedItem.selected = NO;
    self.selectedItem = tabBarItem;
    self.selectedItem.selected = YES;
}

- (void)centerBtnPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectedCenter:)]) {
        
        [self.delegate tabBar:self didSelectedCenter:sender];
    }
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat offx = 12.0f;
    CGFloat w = self.frame.size.width - offx*2;
    CGFloat h = self.frame.size.height;
    
    int count = (int)self.tabBarItems.count + 1;
    CGFloat itemY = 0;
    CGFloat itemW = w / count;
    CGFloat itemH = h;
    
    for (int index = 0; index < count; index++) {
        CGFloat itemX = index * itemW + offx;
        
        if (index == 2) {
            self.centerItem.frame = CGRectMake(itemX, itemY, itemW, itemH);
        } else if (index < 2){
            TDTabBarItem *tabBarItem = self.tabBarItems[index];
            tabBarItem.tag = index;
            tabBarItem.frame = CGRectMake(itemX, itemY, itemW, itemH);
        } else {
            TDTabBarItem *tabBarItem = self.tabBarItems[index-1];
            tabBarItem.tag = index-1;
            tabBarItem.frame = CGRectMake(itemX, itemY, itemW, itemH);
        }
    }
}

@end
