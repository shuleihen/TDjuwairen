//
//  MTabBarController.m
//  TDjuwairen
//
//  Created by 团大 on 16/6/27.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "MTabBarController.h"

@interface MTabBarController ()

@end

@implementation MTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITabBar *tabbar = self.tabBar;
    UITabBarItem *item1 = [tabbar.items objectAtIndex:0];
    UITabBarItem *item2 = [tabbar.items objectAtIndex:1];
    UITabBarItem *item3 = [tabbar.items objectAtIndex:2];
    UITabBarItem *item4 = [tabbar.items objectAtIndex:3];
    
    item1.selectedImage  = [[UIImage imageNamed:@"调研－选中@3x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item1.image = [[UIImage imageNamed:@"调研－未选中@3x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    item2.selectedImage = [[UIImage imageNamed:@"观点－选中@3x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item2.image = [[UIImage imageNamed:@"观点－未选中@3x"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item3.selectedImage = [[UIImage imageNamed:@"视频－选中@3x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item3.image = [[UIImage imageNamed:@"视频－未选中@3x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item4.selectedImage = [[UIImage imageNamed:@"个人中心－选定@3x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item4.image = [[UIImage imageNamed:@"个人中心－未选定@3x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.tabBarController.tabBar.translucent = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
