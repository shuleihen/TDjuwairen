//
//  UIViewController+Login.m
//  TDjuwairen
//
//  Created by zdy on 2017/3/20.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "UIViewController+Login.h"
#import "LoginViewController.h"

@implementation UIViewController (Login)

- (void)pushLoginViewController {
    LoginViewController *login = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:login animated:YES];
}
@end
