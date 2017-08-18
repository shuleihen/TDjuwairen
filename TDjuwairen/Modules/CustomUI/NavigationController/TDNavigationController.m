//
//  TDNavigationController.m
//  TDjuwairen
//
//  Created by zdy on 16/8/2.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "TDNavigationController.h"
#import "UIImage+Color.h"

@interface NavgiationDelegate : NSObject<UINavigationControllerDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, weak) UINavigationController *navController;
@end

@implementation NavgiationDelegate

- (id)initWithNavigationController:(UINavigationController *)nav
{
    if (self = [super init]) {
        self.navController = nav;
    }
    
    return self;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // viewcontroller 不延伸到状态栏下
    viewController.edgesForExtendedLayout = UIRectEdgeNone;
    
    NSString *classString = NSStringFromClass([viewController class]);
    BOOL hidden = [self isHiddenNavigationBarWithViewController:classString];
    [navigationController setNavigationBarHidden:hidden animated:animated];
    
    [self setupNavigationControllerBackground:navigationController willShowViewController:viewController];
    
    if ([navigationController.viewControllers count] > 1) {
        if (!viewController.navigationItem.leftBarButtonItem) {
            UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
            left.frame = CGRectMake(0, 0, 30, 24);
            
            UIImage *image = [[UIImage imageNamed:@"nav_back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
            viewController.navigationItem.leftBarButtonItem = leftBar;
        }
    }
}

- (void)back:(id)sender
{
    [self.navController popViewControllerAnimated:YES];
}

- (BOOL)isHiddenNavigationBarWithViewController:(NSString *)className {
    
    __block BOOL hidden = NO;
    
    NSArray *filtArray = @[@"CenterViewController",
                           @"AliveRoomViewController",
                           @"SearchViewController",
                           @"UserInfoViewController",
                           @"PersonalCenterViewController",
                           @"AliveSearchAllTypeViewController",
                           @"VideoDetailViewController",
                           @"StockPoolSearchViewController"];
    [filtArray enumerateObjectsUsingBlock:^(NSString *string, NSUInteger idx, BOOL *stop){
        if ([string isEqualToString:className]) {
            hidden = YES;
            *stop = YES;
        }
    }];
    
    return hidden;
}

- (UIImage *)navBackgroundImageWithController:(NSString *)className {
    if ([className isEqualToString:@"AliveListRootViewController"] ||
        [className isEqualToString:@"StockPoolListViewController"] ||
        [className isEqualToString:@"StockPoolAddAndEditViewController"]) {
        return [UIImage imageNamed:@"nav_bg.png"];
    }
    return nil;
}

- (void)setupNavigationControllerBackground:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController {
    UIImage *image = [self navBackgroundImageWithController:NSStringFromClass([viewController class])];
    if (image) {
        [navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
        
        UIImage *shadow = [UIImage imageWithSize:CGSizeMake(kScreenWidth, TDPixel) withColor:[UIColor clearColor]];
        [navigationController.navigationBar setShadowImage:shadow];
    } else {
        [navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        [navigationController.navigationBar setShadowImage:nil];
    }
}
@end



@interface TDNavigationController ()
@property (nonatomic, strong) NavgiationDelegate *navDelegate;
@end

@implementation TDNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.translucent = NO;
    self.navigationBar.barTintColor = [UIColor whiteColor];
    
    self.navDelegate = [[NavgiationDelegate alloc] initWithNavigationController:self];
    self.delegate = self.navDelegate;
    self.interactivePopGestureRecognizer.delegate = self.navDelegate;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end


