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
#import "SettingHandler.h"

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


#pragma mark - XXTabBarDelegate Method

- (void)tabBar:(TDTabBar *)tabBarView didSelectedCenter:(id)sender {
    TDPopupMenuViewController *vc = [[TDPopupMenuViewController alloc] init];
    UIImage *image = [UIImage imageWithCaputureView:self.view];
    vc.backImg = image;
    vc.delegate = self;
    [self presentViewController:vc animated:NO completion:nil];
}

- (BOOL)tabBar:(TDTabBar *)tabBarView shouldSelectItemIndex:(NSInteger)index {
    
    return YES;
}

- (void)tabBar:(TDTabBar *)tabBarView didSelectedItemFrom:(NSInteger)from to:(NSInteger)to {
    
    self.selectedIndex = to;
}

#pragma mark - TDPopupMenuDelegate
- (void)popupMenu:(TDPopupMenuViewController *)popupMenu withIndex:(NSInteger)selectedIndex {
    UINavigationController *nav = self.selectedViewController;
    
    if (!US.isLogIn) {
        LoginViewController *login = [[LoginViewController alloc] init];
        login.hidesBottomBarWhenPushed = YES;
        [nav pushViewController:login animated:YES];
        return;
    }
    
    
    if (selectedIndex == 0) {
        // 话题
        AlivePublishViewController *vc = [[AlivePublishViewController alloc] initWithStyle:UITableViewStyleGrouped];
        vc.hidesBottomBarWhenPushed = YES;
        vc.publishType = kAlivePublishNormal;
        [nav pushViewController:vc animated:YES];
    } else if (selectedIndex == 1) {
        // 推单
        AlivePublishViewController *vc = [[AlivePublishViewController alloc] initWithStyle:UITableViewStyleGrouped];
        vc.hidesBottomBarWhenPushed = YES;
        vc.publishType = kAlivePublishPosts;
        [nav pushViewController:vc animated:YES];
    } else if (selectedIndex == 2) {
        // 观点
        PublishViewViewController *publishview = [[PublishViewViewController alloc] init];
        publishview.hidesBottomBarWhenPushed = YES;
        [nav pushViewController:publishview animated:YES];
        
    } else if (selectedIndex == 3) {
        // 股票池记录，每天只能发2条
        if (popupMenu.canPublishStockPool == NO) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"股票池每天只能发两次哦,等过了凌晨4点再来吧~\n或者您可以删除最新的记录重新发" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *done = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:done];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            StockPoolAddAndEditViewController *vc = [[StockPoolAddAndEditViewController alloc] init];
            
            TDNavigationController *editNav = [[TDNavigationController alloc] initWithRootViewController:vc];
            [nav presentViewController:editNav animated:YES completion:nil];
        }
    }
}
@end
