//
//  TDNavigationController.m
//  TDjuwairen
//
//  Created by zdy on 16/8/2.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "TDNavigationController.h"

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

@end


@interface TDNavigationController ()
@property (nonatomic, strong) NavgiationDelegate *navDelegate;
@end

@implementation TDNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.translucent = NO;
    
    self.navDelegate = [[NavgiationDelegate alloc] initWithNavigationController:self];
    self.delegate = self.navDelegate;
    self.interactivePopGestureRecognizer.delegate = self.navDelegate;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end


