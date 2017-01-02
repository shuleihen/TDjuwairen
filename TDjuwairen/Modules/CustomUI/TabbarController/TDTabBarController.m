//
//  TDTabBarController.m
//  TDjuwairen
//
//  Created by zdy on 2017/1/2.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "TDTabBarController.h"

@interface TDTabBarController ()

@end

@implementation TDTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tabBar.translucent = NO;
    self.tabBar.dk_barTintColorPicker = DKColorPickerWithKey(BAR);
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
