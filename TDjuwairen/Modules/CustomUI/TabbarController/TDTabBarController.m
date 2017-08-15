//
//  TDTabBarController.m
//  TDjuwairen
//
//  Created by zdy on 2017/1/2.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "TDTabBarController.h"
#import "HexColors.h"
#import "LoginViewController.h"
#import "TDNavigationController.h"
#import "CenterViewController.h"
#import "TDTabBar.h"
#import "TDTabBarItem.h"
#import "TDPopupMenuViewController.h"
#import "UIImage+Caputure.h"
#import "PublishViewViewController.h"
#import "AlivePublishViewController.h"
#import "StockPoolAddAndEditViewController.h"

@interface TDTabBarController ()<TDTabBarDelegate, TDPopupMenuDelegate>
@property (nonatomic, strong) TDTabBar *lcTabBar;
@end

@implementation TDTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TDTabBar *tabBar = [[TDTabBar alloc] init];
    tabBar.backgroundColor = [UIColor whiteColor];
    tabBar.frame     = self.tabBar.bounds;
    tabBar.delegate  = self;
    
    self.tabBar.translucent = NO;
    [self.tabBar addSubview:tabBar];
    self.lcTabBar = tabBar;
    
    [self setupViewControllers:self.viewControllers];
    
    self.selectedIndex = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStatusChanged:) name:kLoginStateChangedNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [[self tabBar] bringSubviewToFront:self.lcTabBar];
}

- (void)removeOriginControls {
    
    [self.tabBar.subviews enumerateObjectsUsingBlock:^(__kindof UIView * obj, NSUInteger idx, BOOL * stop) {
        
        if ([obj isKindOfClass:[UIControl class]]) {
            
            [obj removeFromSuperview];
        }
    }];
}

- (void)setupViewControllers:(NSArray *)viewControllers {
    
    self.lcTabBar.badgeTitleFont         = [UIFont systemFontOfSize:9];
    self.lcTabBar.itemTitleFont          = [UIFont systemFontOfSize:11];
    self.lcTabBar.itemImageRatio         = 1.0;
    self.lcTabBar.itemTitleColor         = TDLightGrayColor;
    self.lcTabBar.selectedItemTitleColor = TDThemeColor;
    
    self.lcTabBar.tabBarItemCount = viewControllers.count;
    
    [viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        UIViewController *VC = (UIViewController *)obj;
        
        UIImage *selectedImage = VC.tabBarItem.selectedImage;
        VC.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        [self addChildViewController:VC];
        
        [self.lcTabBar addTabBarItem:VC.tabBarItem];
    }];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    
    [super setSelectedIndex:selectedIndex];
    
    self.lcTabBar.selectedItem.selected = NO;
    self.lcTabBar.selectedItem = self.lcTabBar.tabBarItems[selectedIndex];
    self.lcTabBar.selectedItem.selected = YES;
}

- (void)loginStatusChanged:(id)sender {
    if (self.selectedIndex == 3) {
        self.selectedIndex = 0;
    }
}

#pragma mark - XXTabBarDelegate Method

- (void)tabBar:(TDTabBar *)tabBarView didSelectedCenter:(id)sender {
    TDPopupMenuViewController *vc = [[TDPopupMenuViewController alloc] init];
    UIImage *image = [UIImage imageWithCaputureView:self.view];
    vc.backImg = image;
    vc.delegate = self;
    [self presentViewController:vc animated:NO completion:nil];
}

- (BOOL)tabBar:(TDTabBar *)tabBarView shouldSelectItemIndex:(NSInteger)index {
    
    if (index == 3 && !US.isLogIn) {
        UINavigationController *nav = self.selectedViewController;
        LoginViewController *login = [[LoginViewController alloc] init];
        login.hidesBottomBarWhenPushed = YES;
        [nav pushViewController:login animated:YES];
        
        return NO;
    } else {
        return YES;
    }
}

- (void)tabBar:(TDTabBar *)tabBarView didSelectedItemFrom:(NSInteger)from to:(NSInteger)to {
    
    self.selectedIndex = to;
}

#pragma mark - TDPopupMenuDelegate
- (void)popupMenu:(id)popupMenu withIndex:(NSInteger)selectedIndex {
    UINavigationController *nav = self.selectedViewController;
    
    if (!US.isLogIn) {
        LoginViewController *login = [[LoginViewController alloc] init];
        login.hidesBottomBarWhenPushed = YES;
        [nav pushViewController:login animated:YES];
        return;
    }
    
    
    if (selectedIndex == 0) {
        //跳转到发布页面
        PublishViewViewController *publishview = [[PublishViewViewController alloc] init];
        publishview.hidesBottomBarWhenPushed = YES;
        [nav pushViewController:publishview animated:YES];
    } else if (selectedIndex == 1) {
        // 推单
        AlivePublishViewController *vc = [[AlivePublishViewController alloc] initWithStyle:UITableViewStyleGrouped];
        vc.hidesBottomBarWhenPushed = YES;
        vc.publishType = kAlivePublishPosts;
        [nav pushViewController:vc animated:YES];
    } else if (selectedIndex == 2) {
        // 话题
        AlivePublishViewController *vc = [[AlivePublishViewController alloc] initWithStyle:UITableViewStyleGrouped];
        vc.hidesBottomBarWhenPushed = YES;
        vc.publishType = kAlivePublishNormal;
        [nav pushViewController:vc animated:YES];
    } else if (selectedIndex == 3) {
        // 股票池记录
        StockPoolAddAndEditViewController *vc = [[StockPoolAddAndEditViewController alloc] init];
        
        TDNavigationController *editNav = [[TDNavigationController alloc] initWithRootViewController:vc];
        [nav presentViewController:editNav animated:YES completion:nil];
    }
}
@end
