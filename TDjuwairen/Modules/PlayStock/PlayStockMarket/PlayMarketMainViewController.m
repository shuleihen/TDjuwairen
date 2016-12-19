//
//  PlayMarketMainViewController.m
//  TDjuwairen
//
//  Created by zdy on 2016/12/19.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "PlayMarketMainViewController.h"
#import "StockMarketViewController.h"
#import "StockMarketRuleViewController.h"
#import "UIImage+Color.h"
#import "HexColors.h"


@interface PlayMarketMainViewController ()
@property (nonatomic, strong) UISegmentedControl *segment;
@end

@implementation PlayMarketMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    StockMarketViewController *sz = [[UIStoryboard storyboardWithName:@"PlayStock" bundle:nil] instantiateViewControllerWithIdentifier:@"StockMarketViewController"];
    sz.tabBarItem.title = @"上证指数";
    [self setupTabBarItem:sz.tabBarItem];
    sz.stockType = kStockTypeSZ;
    
    StockMarketViewController *cy = [[UIStoryboard storyboardWithName:@"PlayStock" bundle:nil] instantiateViewControllerWithIdentifier:@"StockMarketViewController"];
    cy.tabBarItem.title = @"创业板指数";
    [self setupTabBarItem:cy.tabBarItem];
    cy.stockType = kStockTypeCY;
    
    StockMarketRuleViewController *gz = [[StockMarketRuleViewController alloc] init];
    gz.tabBarItem.title = @"游戏规则";
    [self setupTabBarItem:gz.tabBarItem];
    self.viewControllers = @[sz,cy,gz];
    
    
    UIImage *bgImage = [UIImage imageWithSize:CGSizeMake(kScreenWidth, 50) withColor:[UIColor hx_colorWithHexRGBAString:@"#f46503"]];
    UIImage *shadowImage = [UIImage imageWithSize:CGSizeMake(kScreenWidth, 1) withColor:[UIColor hx_colorWithHexRGBAString:@"#f46503"]];
    [self.tabBar setBackgroundImage:bgImage];
    [self.tabBar setShadowImage:shadowImage];
    
    UIImage *indicatorImage = [UIImage imageWithSize:CGSizeMake(kScreenWidth/3, 50) withColor:[UIColor hx_colorWithHexRGBAString:@"#e34f08"]];
    self.tabBar.selectionIndicatorImage = indicatorImage;
}

- (void)setupTabBarItem:(UITabBarItem *)item {
    [item setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f],
                                            NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateNormal];
    [item setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f],
                                            NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateSelected];
    item.titlePositionAdjustment = UIOffsetMake(0, -15);
}
@end
